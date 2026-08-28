cask "brave-origin-linux" do
  version "1.94.117"
  sha256 "c821c649fc17d451764a771d2b5da5e00515c4d531fdf4896548ca86da3b531e"

  url "https://github.com/brave/brave-browser/releases/download/v#{version}/brave-origin-#{version}-linux-amd64.zip",
      verified: "github.com/brave/brave-browser/"
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

  preflight do
    FileUtils.mkdir_p("#{Dir.home}/.local/share/applications")
    FileUtils.mkdir_p("#{Dir.home}/.local/share/icons")

    File.write("#{staged_path}/brave-origin.desktop", <<~EOS)
      [Desktop Entry]
      Version=1.0
      Name=Brave Origin
      GenericName=Web Browser
      Comment=Minimalist privacy-focused browser from Brave
      Exec=#{HOMEBREW_PREFIX}/bin/brave-origin %U
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
      Exec=#{HOMEBREW_PREFIX}/bin/brave-origin

      [Desktop Action new-private-window]
      Name=New Incognito Window
      Exec=#{HOMEBREW_PREFIX}/bin/brave-origin --incognito
    EOS
  end

  postflight do
    sandbox = "#{staged_path}/chrome-sandbox"
    FileUtils.chmod(04755, sandbox) if File.exist?(sandbox)
  end

  zap trash: [
    "#{Dir.home}/.cache/BraveSoftware/Brave-Browser-Origin",
    "#{Dir.home}/.config/BraveSoftware/Brave-Browser-Origin",
  ]
end
