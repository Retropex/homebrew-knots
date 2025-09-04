class Knots < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoinknots.org/"
  url "https://bitcoinknots.org/files/29.x/29.1.knots20250903/bitcoin-29.1.knots20250903.tar.gz"
  version "29.1"
  sha256 "d8394994636b08e7bc528b99f932dd67639a854d7c0162fa2bf288d58036f506"
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

  def install
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
