cask 'chromium' do
  version '762671'
  sha256 '98b64cb71cbfd502f73853dae27f5e364f5a7a16e8fb8a577d25107831e6fbbc'

  # commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/ was verified as official when first introduced to the cask
  url "https://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/#{version}/chrome-mac.zip"
  appcast 'https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Mac%2FLAST_CHANGE?alt=media'
  name 'Chromium'
  homepage 'https://www.chromium.org/Home'

  conflicts_with cask: [
                         'eloston-chromium',
                         'freesmug-chromium',
                       ]

  app 'chrome-mac/Chromium.app'
  # shim script (https://github.com/Homebrew/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/chromium.wrapper.sh"
  binary shimscript, target: 'chromium'

  preflight do
    IO.write shimscript, <<~EOS
      #!/bin/sh
      '#{appdir}/Chromium.app/Contents/MacOS/Chromium' "$@"
    EOS
  end

  zap trash: [
               '~/Library/Application Support/Chromium',
               '~/Library/Caches/Chromium',
               '~/Library/Preferences/org.chromium.Chromium.plist',
               '~/Library/Saved Application State/org.chromium.Chromium.savedState',
             ]
end
