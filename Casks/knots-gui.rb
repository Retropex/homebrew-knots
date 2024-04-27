cask "knots-gui" do
    arch arm: "arm64", intel: "x86_64"
  
    version "26.1"
    sha256 arm:   "13f14027c1371c332701acb92b1a9a20376febee779ace0209fc2a2e471f3b2d",
           intel: "28870b4db6de08409ea8c67d89a210bd2fb992483ccc02d0312241af65094caf"
  
    url "https://bitcoinknots.org/files/26.x/26.1.knots20240325/bitcoin-26.1.knots20240325-#{arch}-apple-darwin.zip"
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