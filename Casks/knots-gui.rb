cask "knots-gui" do
    arch arm: "arm64", intel: "x86_64"
  
    version "29.4"
    sha256 arm:   "4218c01abf01aad7086dc4a1c332c0ea3e110aacf65dc6bc7e1f35d443725acb",
           intel: "c054aef2142be9cbb247515bb2cdc302672d7676ab81a5e91cfe8f61271534d1"
  
    url "https://bitcoinknots.org/files/29.x/29.4.knots20260508/bitcoin-29.4.knots20260508-#{arch}-apple-darwin.zip"
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