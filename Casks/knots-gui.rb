cask "knots-gui" do
    arch arm: "arm64", intel: "x86_64"
  
    version "27.1.1"
    sha256 arm:   "030587371794f02c1f847b28638e139e9c3ceedf6512b2fdab5c8500e8ea01e3",
           intel: "ec33a8a9e66c3d0aa6738cb72853526f5949e819d69e695aff5138916adf4243"
  
    url "https://bitcoinknots.org/files/27.x/27.1.knots20240801/bitcoin-27.1.knots20240801-#{arch}-apple-darwin.zip"
    name "Bitcoin Knots"
    desc "Bitcoin node"
    homepage "https://bitcoinknots.org/"
  
    depends_on macos: ">= :big_sur"
  
    # Renamed for consistency: app name is different in the Finder and in a shell.
    app "Bitcoin-Qt.app", target: "Bitcoin Knots.app"
  
    preflight do
      set_permissions "#{staged_path}/Bitcoin-Qt.app", "0755"
    end
  
    zap trash: "~/Library/Preferences/org.bitcoin.Bitcoin-Qt.plist"
end