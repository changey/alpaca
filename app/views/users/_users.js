<script
type = "text/javascript" > $(function() {

	var locale = "";

	//alert(I18n.t("hello"));

	//the javascript to load the user page
	var rowNumber = 4;
	var colNumber = 5;
	// maximum number of profiles shown
	var MAX_COUNT = 100;

	var container = document.getElementById("container");
	var div = document.createElement("div");
	div.className = "box photo col3";
	var a = document.createElement("a");
	var img = document.createElement("img");

	img.src = "http://graph.facebook.com/changey2/picture?width=180";
	a.appendChild(img);
	div.appendChild(a);

	var ind = 0;
	var i = 0;
	var j = 0
	var cell;
	var length = document.URL.length;
	var url = "";
	var locale = "";
	if (document.URL.substring(length - 4, length) == "#_=_") {
		url = document.URL.substring(0, length - 4);
	} else if (document.URL.indexOf("=en") != -1) {
		url = document.URL.substring(0, length - 10);
		locale = "en";
	} else if (document.URL.indexOf("=th") != -1) {
		url = document.URL.substring(0, length - 10);
		locale = "th";
	} else if (document.URL.indexOf("=zh_tw") != -1) {
		url = document.URL.substring(0, length - 13);
		locale = "zh_tw";
	} else if (document.URL.indexOf("=zh_cn") != -1) {
		url = document.URL.substring(0, length - 13);
		locale = "zh_cn";
	} else {
		url = document.URL;
	}

	var count = 0;

	$.getJSON(url + "/showfriendslist", function(data) {

		$.each(data, function(index, value) {
			availableNames.push(value["name"]);
			fbids.push(value["fbid"]);
		});

		shuffle(data, MAX_COUNT);

		var friends = [];

		// show users with existing profiles first
		$.each(data, function(index, value) {
			if (value["id"] !== undefined) {
				friends.push(value);
			}
		});

		$.each(data, function(index, value) {
			if (value["id"] === undefined) {
				friends.push(value);
			}
		});

		locale = "<%= I18n.locale %>";

		$.each(friends, function(index, value) {
			// In MVP, we limit number of displayed friends to 50.
			// In extension, we will implement dynamically loading friends.
			if (count < MAX_COUNT) {
				i = parseInt(count / colNumber);
				j = count % colNumber;
				cell = document.getElementById("" + i + j);

				if (value["fbid"]) {
					link = "/"+locale+"/profiles/show_profile/" + value["fbid"];
				} else {
					link = "/"+locale+"/profiles/new?fbid=" + value["fbid"];
				}
				add_pic_and_name(value["fbid"], value["name"], link);
				count++;

				$(function() {

					var $container = $("#container");
					var $item = $container.find(".box").eq(0);

					$container.imagesLoaded(function() {
						$container.masonry({
							itemSelector : ".box",
						});
					});
				});
			}
		});
	});

	var availableNames = [];
	var fbids = [];

	var index;
	var fbid;

	//the autocomplete function used to let users search for the friends he/she wants to add
	$("#tags").autocomplete({

		source : availableNames,
		select : function(e, ui) {
			index = availableNames.indexOf(ui.item.value);
			fbid = fbids[index];
		}
	}).data("uiAutocomplete")._renderItem = function(ul, item) {

		return $("<li />").data("item.autocomplete", item).append("<a><img src=\"http://graph.facebook.com/" + fbids[availableNames.indexOf(item.label)] + "/picture\" /> " + item.label + "</a>").appendTo(ul);
	};

	$("#btnNew").click(function(evt) {
		
		locale = "<%= I18n.locale %>";
		
		if (fbid != undefined) {
			window.location = "/"+locale+"/profiles/show_profile/" + fbid;
		}
	});

});

//the method to add the picture of a profile
function add_pic_and_name(fbid, name, link) {

	var container = document.getElementById("container");
	var div = document.createElement("div");
	div.className = "box photo col3";
	var a = document.createElement("a");
	a.href = link;
	var img = document.createElement("img");
	img.src = "http://graph.facebook.com/" + fbid + "/picture?width=180";
	img.className = "img";

	var text = document.createTextNode(name);
	a.appendChild(img);
	a.appendChild(text);
	div.appendChild(a);

	container.appendChild(div);

}

function shuffle(arr, count) {
	for (var i = 0 ; i < count && i < arr.length ; i ++) {
		var j = Math.floor(Math.random() * (arr.length));
		var tmp = arr[i];
		arr[i] = arr[j];
		arr[j] = tmp;
	}
}

</script>