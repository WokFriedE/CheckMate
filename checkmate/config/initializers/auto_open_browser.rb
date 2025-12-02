if Rails.env.development? && ENV["AUTO_OPEN_BROWSER"] != "false"
  Thread.new do
    sleep 2 # give Puma a moment to boot
    chrome_path = if RbConfig::CONFIG["host_os"] =~ /mswin|mingw|cygwin/
                    # Windows path to Chrome
                    '"C:\Program Files\Google\Chrome\Application\chrome.exe"'
                  elsif RbConfig::CONFIG["host_os"] =~ /darwin/
                    # macOS path
                    "open -a 'Google Chrome'"
                  else
                    # Linux
                    "google-chrome"
                  end

    system("#{chrome_path} http://localhost:3000")
  end
end
