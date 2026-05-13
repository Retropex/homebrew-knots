cask "knots-gui" do
    arch arm: "arm64", intel: "x86_64"
  
    version "29.3.3"
    sha256 arm:   "92d34a8ca1d3f4e40b869be340375203cf5fc6e9c6729dbf5a9c923cbe6a733e",
           intel: "8a145f0a88407bf551bea9c3bbd77bf7c9edd4473c6e2280e716457a8e786bc3"
  
    url "https://bitcoinknots.org/files/29.x/29.3.knots20260508/bitcoin-29.3.knots20260508-#{arch}-apple-darwin.zip"
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