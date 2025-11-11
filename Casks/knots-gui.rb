cask "knots-gui" do
    arch arm: "arm64", intel: "x86_64"
  
    version "29.2.2"
    sha256 arm:   "db162ae8b6198278da6657d00eddf6f642fd5dccdbc32b124fad6a26e6f4ece1",
           intel: "a736c6a64f4e300ef0cda8d0106f341daad86fb1012eeeaf3e5136c556eba660"
  
    url "https://bitcoinknots.org/files/29.x/29.2.knots20251110/bitcoin-29.2.knots20251110-#{arch}-apple-darwin.zip"
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