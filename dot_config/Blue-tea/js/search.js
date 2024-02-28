
//ADD JQUERY

/*(function() {
/    var startingTime = new Date().getTime();
    // Load the script
    var script = document.createElement("SCRIPT");
    script.src = 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js';
    script.type = 'text/javascript';
    document.getElementsByTagName("head")[0].appendChild(script);

    // Poll for jQuery to come into existance
    var checkReady = function(callback) {
        if (window.jQuery) {
            callback(jQuery);
        }
        else {
            window.setTimeout(function() { checkReady(callback); }, 20);
        }
    };

    // Start polling...
    checkReady(function($) {
        $(function() {
            var endingTime = new Date().getTime();
            var tookTime = endingTime - startingTime;
        });
    });
})(); */

function createUnorderedList(list, bulletChar, avvertimento) {
  var result = "";
  for (var i = 0; i<list.length; ++i) {
    result += bulletChar + " " + list[i] + "\n";
  }
  result += avvertimento;
  return result;
}

function lista() {
  var avvertimento = "Example : \"-a chair\" to search on amazon or \"-n family gui\" to search on netflix";
  var bulletChar = "•";
  var list = ["-a   Amazon", "-d   Duckduckgo", "-g   Github", "-n   Netflix", "-r    Reddit","-s    Spotify","-w   Archwiki", "-y    Youtube"]
  alert(createUnorderedList(list, bulletChar, avvertimento));
}


String.prototype.replaceChars = function (character, replacement) {
	var str = this;
	var a;
	var b;
	for (var i = 0; i < str.length; i++) {
		if (str.charAt(i) === character) {
			a = str.substr(0, i) + replacement;
			b = str.substr(i + 1);
			str = a + b;
		}
	}
	return str;
}

function search(query) {
	switch (query.substr(0, 2)) {
		case '-d':
			query = query.substr(3);
			window.open('https://duckduckgo.com/' +
				query.replaceChars(' ', '%20'), '_blank');
			break;
		case '-y':
			query = query.substr(3);
			window.open('https://www.youtube.com/results?search_query=' +
				query.replaceChars(' ', '%20'), '_blank');
			break;
		case '-a':
			query = query.substr(3);
			window.open(
				'https://www.amazon.it/s?k=' +
				query.replaceChars(' ', '%20'), '_blank');
			break;
		case '-r':
			query = query.substr(3);
			window.open(
				'https://www.reddit.com/r/' +
				query.replaceChars(' ', '%20'), '_blank');
			break;
		case '-w':
			query = query.substr(3);
			window.open(
				'https://wiki.archlinux.org/index.php?search=' +
				query.replaceChars(' ', '%20'), '_blank');
			break;
		case '-s':
			query = query.substr(3);
			window.open(
				'https://open.spotify.com/search/' +
				query.replaceChars(' ', '%20'), '_blank');
			break;
		case '-n':
			query = query.substr(3);
			window.open(
				'https://www.netflix.com/search?q=' +
				query.replaceChars(' ', '%20'), '_blank');
			break;
		case '-g':
			query = query.substr(3);
			window.open(
				'https://github.com/search?q=' +
				query.replaceChars(' ', '%20'), '_blank');
			break;
		case '-h':
			lista();
			break;
		default:
			window.open('https://www.google.com/search?q=' +
				query.replaceChars(' ', '%20'), '_blank');
	}
}

searchInput = document.getElementById('searchbox');

searchInput.focus();

searchInput.addEventListener('keyup', function (e) {
	if (e.keyCode === 13) {
		if (searchInput.value === '') {
			searchInput.placeholder = 'type something...';
		} else {
			search(this.value);
			searchInput.value = '';
			searchInput.placeholder = 'Search or -h for help';
		}
	}
});




