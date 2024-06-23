cask "knots-gui" do
    arch arm: "arm64", intel: "x86_64"
  
    version "27.1"
    sha256 arm:   "2041f45f8438a2dfec1ff40718769351c74f8e3a71b0849dab92ae477aba144a",
           intel: "d5648998abd431511d7d25ce9c3246322d07a136c9478d895f7911820f82a7d5"
  
    url "https://bitcoinknots.org/files/27.x/27.1.knots20240621/bitcoin-27.1.knots20240621-#{arch}-apple-darwin.zip"
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