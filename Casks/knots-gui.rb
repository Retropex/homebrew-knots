cask "knots-gui" do
    arch arm: "arm64", intel: "x86_64"
  
    version "29.1"
    sha256 arm:   "97cee269b2f418db2868bcdc8e2a20c2f27fbb69f3541b35acaf3ddab1e39f85",
           intel: "52e358c2516067205756a94ee37c52a9e8c9df9c8186b523669bbc95aeb6b150"
  
    url "https://bitcoinknots.org/files/29.x/29.1.knots20250903/bitcoin-29.1.knots20250903-#{arch}-apple-darwin.zip"
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