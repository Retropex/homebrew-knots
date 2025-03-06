cask "knots-gui" do
    arch arm: "arm64", intel: "x86_64"
  
    version "28.1"
    sha256 arm:   "ceaab0dd63d09c012bba8445beee4eddf43522083830dacaee67b8f3d21f2f3a",
           intel: "feacbd817dd279129e568f22b9b8fb181e99791b791e43bf5b4215163c7ed3cb"
  
    url "https://bitcoinknots.org/files/28.x/28.1.knots20250305/bitcoin-28.1.knots20250305-#{arch}-apple-darwin.zip"
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