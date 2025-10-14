class Knots < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoinknots.org/"
  url "https://bitcoinknots.org/files/29.x/29.2.knots20251010/bitcoin-29.2.knots20251010.tar.gz"
  version "29.2"
  sha256 "a77a2671f817e7bade1d7417dc81bc14f98ccbc307482374f83f4785bdb859c9"
  license "MIT"
  head "https://github.com/bitcoinknots/bitcoin", branch: "29.x-knots"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  # berkeley db should be kept at version 4
  # https://github.com/bitcoin/bitcoin/blob/master/doc/build-osx.md
  # https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on macos: :big_sur
  depends_on "zeromq"

  uses_from_macos "sqlite"

  fails_with :gcc do
    version "7" # fails with GCC 7.x and earlier
    cause "Requires std::filesystem support"
  end

resource "bdb" do
    url "https://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz"
    sha256 "12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef"

    # Fix build with recent clang
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/4c55b1/berkeley-db%404/clang.diff"
      sha256 "86111b0965762f2c2611b302e4a95ac8df46ad24925bbb95a1961542a1542e40"
    end
    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
      directory "dist"
    end
  end

  def install
    # https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md#berkeley-db
    # https://github.com/bitcoin/bitcoin/blob/master/depends/packages/bdb.mk
    resource("bdb").stage do
      with_env(CFLAGS: ENV.cflags) do
        # Fix compile with newer Clang
        ENV.append "CFLAGS", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200
        # Fix linking with static libdb
        ENV.append "CFLAGS", "-fPIC" if OS.linux?

        args = ["--disable-replication", "--disable-shared", "--enable-cxx"]
        args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

        # BerkeleyDB requires you to build everything from the build_unix subdirectory
        cd "build_unix" do
          system "../dist/configure", *args, *std_configure_args(prefix: buildpath/"bdb")
          system "make", "libdb_cxx-4.8.a", "libdb-4.8.a"
          system "make", "install_lib", "install_include"
        end
      end
    end

    ENV.runtime_cpu_detection
    args = %W[
      -DWITH_BDB=ON
      -DBerkeleyDB_INCLUDE_DIR:PATH=#{buildpath}/bdb/include
      -DWITH_ZMQ=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "share/rpcauth"
  end

  service do
    run opt_bin/"bitcoind"
  end

  test do
    system "#{bin}/test_bitcoin"

    # Test that we're using the right version of `berkeley-db`.
    port = free_port
    bitcoind = spawn bin/"bitcoind", "-regtest", "-rpcport=#{port}", "-listen=0", "-datadir=#{testpath}",
                                     "-deprecatedrpc=create_bdb"
    sleep 15
    # This command will fail if we have too new a version.
    system bin/"bitcoin-cli", "-regtest", "-datadir=#{testpath}", "-rpcport=#{port}",
                              "createwallet", "test-wallet", "false", "false", "", "false", "false"
  ensure
    Process.kill "TERM", bitcoind
  end
end
