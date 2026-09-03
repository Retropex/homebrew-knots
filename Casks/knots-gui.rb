cask "knots-gui" do
    arch arm: "arm64", intel: "x86_64"
  
    version "29.4.1"
    sha256 arm:   "af630b2ebb5d3b6124a82386ad6298f1518fee2a60a62adc5614b7025fdcece2",
           intel: "e6c0874597b4c00634fa8adb458d1ef0407462b797064f440e272a3ac4416a38"
  
    url "https://bitcoinknots.org/files/29.x/29.4.1.knots20260508/bitcoin-29.4.1.knots20260508-#{arch}-apple-darwin.zip"
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