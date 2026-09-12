cask "brave-origin-linux" do
  version "1.95.101"
  sha256 "7dadff86aefdd1ed49bc39575fc2ef20534a8ab51086f58000f92c70f1fcc1cf"

  url "https://github.com/brave/brave-browser/releases/download/v#{version}/brave-origin-#{version}-linux-amd64.zip"
  name "Brave Origin"
  desc "Minimalist version of the Brave browser"
  homepage "https://brave.com/origin/"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "brave", target: "brave-origin"
  artifact "brave-origin.desktop",
           target: "#{Dir.home}/.local/share/applications/brave-origin.desktop"
  artifact "product_logo_256.png",
           target: "#{Dir.home}/.local/share/icons/brave-origin.png"

  preflight_steps do
    mkdir_p ".local/share/applications", base: :home
    mkdir_p ".local/share/icons/hicolor/512x512/apps", base: :home

    write_file "brave-origin.desktop", <<~EOS
      [Desktop Entry]
      Version=1.0
      Name=Brave Origin
      GenericName=Web Browser
      Comment=Minimalist privacy-focused browser from Brave
      Exec={{HOMEBREW_PREFIX}}/bin/brave-origin %U
      Terminal=false
      Icon=brave-origin
      Type=Application
      Categories=Network;WebBrowser;
      MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
      StartupNotify=true
      StartupWMClass=brave-origin
      Actions=new-window;new-private-window;

      [Desktop Action new-window]
      Name=New Window
      Exec={{HOMEBREW_PREFIX}}/bin/brave-origin

      [Desktop Action new-private-window]
      Name=New Incognito Window
      Exec={{HOMEBREW_PREFIX}}/bin/brave-origin --incognito
    EOS
  end

  postflight_steps do
    set_permissions "chrome-sandbox", "0755"
  end

  zap trash: [
    "#{Dir.home}/.cache/BraveSoftware/Brave-Browser-Origin",
    "#{Dir.home}/.config/BraveSoftware/Brave-Browser-Origin",
  ]
end
