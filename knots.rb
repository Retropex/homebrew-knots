class Knots < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoinknots.org/"
  url "https://github.com/bitcoinknots/bitcoin/releases/download/v25.1.knots20231115/bitcoin-25.1.knots20231115.tar.gz"
  sha256 "b6251beee95cf6701c6ebc443b47fb0e99884880f2661397f964a8828add4002"
  license "MIT"
  head "https://github.com/bitcoinknots/bitcoin", branch: "25.x-knots"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # berkeley db should be kept at version 4
  # https://github.com/bitcoin/bitcoin/blob/master/doc/build-osx.md
  # https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on macos: :big_sur
  depends_on "miniupnpc"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  fails_with :gcc do
    version "7" # fails with GCC 7.x and earlier
    cause "Requires std::filesystem support"
  end

  patch do
    url "https://github.com/bitcoin/bitcoin/commit/e1e3396b890b79d6115dd325b68f456a0deda57f.patch?full_index=1"
    sha256 "b9bb2d6d2ae302bc1bd3956c7e7e66a25e782df5dc154b9d2b17d28b23fda1ad"
  end

  patch do
    url "https://github.com/bitcoin/bitcoin/commit/9c144154bd755e3765a51faa42b8849316cfdeb9.patch?full_index=1"
    sha256 "caeb3c04eda55b260272bfbdb4f512c99dbf2df06b950b51b162eaeb5a98507a"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}"
    system "make", "install"
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
