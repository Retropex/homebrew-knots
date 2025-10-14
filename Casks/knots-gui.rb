cask "knots-gui" do
    arch arm: "arm64", intel: "x86_64"
  
    version "29.2"
    sha256 arm:   "56d3180158305d22d94f37aa0ea4abc3db51d7e69789b33959c0b2de6cc382c1",
           intel: "540de65657b27055bee406f9506f6ecd11ba0ce416c4065fb8de8ee78c2b205c"
  
    url "https://bitcoinknots.org/files/29.x/29.2.knots20251010/bitcoin-29.2.knots20251010-#{arch}-apple-darwin.zip"
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