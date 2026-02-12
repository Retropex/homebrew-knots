cask "knots-gui" do
    arch arm: "arm64", intel: "x86_64"
  
    version "29.3"
    sha256 arm:   "3fecb7be2f80a4fef2cd1be59dd3f0314a52477f94c4cd96e42a01e2f0c1bfcd",
           intel: "5e5350b8032d114a11617c7db27e97999223abd9ab7d27f56658bd6388a8822d"
  
    url "https://bitcoinknots.org/files/29.x/29.3.knots20260210/bitcoin-29.3.knots20260210-#{arch}-apple-darwin.zip"
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