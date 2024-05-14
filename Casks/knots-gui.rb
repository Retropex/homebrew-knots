cask "knots-gui" do
    arch arm: "arm64", intel: "x86_64"
  
    version "26.1.1"
    sha256 arm:   "c571dbe18a8e64fbc222020b2debd12888da2d0d4a51af38e26af5b6ef20742f",
           intel: "008a427935773c61b9e67b6b43e1fe07a12b274f5be02bd775e50fea2ff6f50f"
  
    url "https://bitcoinknots.org/files/26.x/26.1.knots20240513/bitcoin-26.1.knots20240513-#{arch}-apple-darwin.zip"
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