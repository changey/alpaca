<script
type = "text/javascript" > $(function() {
	
	I18n.locale = "<%= I18n.locale %>";

	var categories = ['EQ'];

	$.each(categories, function(index, category) {
		// Add in dropdown menu
		$('#sort_dropdown_menu').append('<li><a id="sort_' + category + '">' + I18n.t(category) + '</a></li>');
		$('#sort_' + category).click(function() {
			$('#container').remove();
			$.getJSON('/users/' +  <%= @user.id %> +'/showfriendskeys', {
				key : category
			}, function(data) {
				var container = document.createElement('div');
				container.setAttribute('id', 'container');
				container.setAttribute('class', 'clearfix');
				document.getElementById('container1').appendChild(container);

				var friends = [];

				// show users with existing profiles first
				$.each(data, function(index, value) {
					if (value["id"] !== undefined) {
						friends.push(value);
					}
				});

				friends.sort(function(a, b) {
					return b.key - a.key
				});

				$.each(data, function(index, value) {
					if (value["id"] === undefined) {
						friends.push(value);
					}
				});

				var count = 0;
				var rowNumber = 4;
				var colNumber = 5;

				$.each(friends, function(index, value) {

					// In MVP, we limit number of displayed friends to 50.
					// In extension, we will implement dynamically loading friends.
					if (count < 50) {
						i = parseInt(count / colNumber);
						j = count % colNumber;
						cell = document.getElementById("" + i + j);
						link = "/profiles/show_profile/" + value["fbid"];
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
		});
	});
});

</script>