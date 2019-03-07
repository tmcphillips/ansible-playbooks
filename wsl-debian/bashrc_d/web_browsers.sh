

# define the locations of the Firefox and Chrome executables in the Windows environment
export FIREFOX_EXECUTABLE='/mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe'
export CHROME_EXECUTABLE='/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'

# define the firefox and chrome aliases
alias firefox=$FIREFOX_EXECUTABLE
alias chrome="$CHROME_EXECUTABLE > /dev/null &"

# make Firefox the default browser
export BROWSER=$FIREFOX_EXECUTABLE
