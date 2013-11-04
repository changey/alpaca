<script type = "text/javascript" >


$(function () {
	
	I18n.locale = "<%= I18n.locale %>";
	
	var max_id = 0;
	var available_ids = [];

	function addNewFilter(plus) {
		var current_id = max_id;
		var trElement = document.createElement('tr');
		trElement.id = 'filteringTd' + current_id;
		trElement.setAttribute('style', 'vertical-align: top;');
		// create plus button (if specify)
		var plusTdElement = document.createElement('td');
		if (plus) {
			var plusButton = document.createElement('i');
			plusButton.setAttribute('class', 'icon-plus');
			plusButton.id = 'icon-plus' + current_id;
			plusTdElement.appendChild(plusButton);
		}
		trElement.appendChild(plusTdElement);
		// create minus button
		var minusTdElement = document.createElement('td');
		var minusButton = document.createElement('i');
		minusButton.setAttribute('class', 'icon-minus');
		minusButton.id = 'icon-minus' + current_id;
		minusTdElement.appendChild(minusButton);
		trElement.appendChild(minusTdElement);
		// Node: 'Category'
		var categoryTdElement = document.createElement('td');
		categoryTdElement.appendChild(document.createTextNode(I18n.t('Category')+':'));
		trElement.appendChild(categoryTdElement);
		// Category Selection
		var categorySelectTdElement = document.createElement('td');
		var categorySelectElement = document.createElement('select');
		categorySelectElement.id = 'categorySelect' + current_id;
		categorySelectElement.setAttribute('style', 'width:150px');
		$.each(['EQ'], function(index, option) {
			var optionElement = document.createElement('option');
			optionElement.setAttribute('value', option);
			optionElement.appendChild(document.createTextNode(I18n.t(option)));
			categorySelectElement.appendChild(optionElement);
		});
		categorySelectTdElement.appendChild(categorySelectElement);
		trElement.appendChild(categorySelectTdElement);
		// Condition Selection
		var conditionSelectTdElement = document.createElement('td');
		var conditionSelectElement = document.createElement('select');
		conditionSelectElement.id = 'conditionSelect' + current_id;
		conditionSelectElement.setAttribute('style', 'width:100px');
		$.each(['at least', 'at most'], function(index, option) {
			var optionElement = document.createElement('option');
			optionElement.setAttribute('value', option);
			optionElement.appendChild(document.createTextNode(I18n.t(option)));
			conditionSelectElement.appendChild(optionElement);
		});
		conditionSelectTdElement.appendChild(conditionSelectElement);
		trElement.appendChild(conditionSelectTdElement);
		// Star Selection
		var starSelectTdElement = document.createElement('td');
		var starSelectElement = document.createElement('select');
		starSelectElement.id = 'starSelect' + current_id;
		starSelectElement.setAttribute('style', 'width:60px');
		$.each(['0.5', '1.0', '1.5', '2.0', '2.5', '3.0', '3.5', '4.0', '4.5', '5.0'], function(index, option) {
			var optionElement = document.createElement('option');
			optionElement.setAttribute('value', option);
			optionElement.appendChild(document.createTextNode(option));
			starSelectElement.appendChild(optionElement);
		});
		starSelectTdElement.appendChild(starSelectElement);
		trElement.appendChild(starSelectTdElement);
		// 'stars' text
		var starTdElement = document.createElement('td');
		starTdElement.appendChild(document.createTextNode(I18n.t('stars')));
		trElement.appendChild(starTdElement);
		// update available ids
		available_ids.push(current_id);
		document.getElementById('filterTable').appendChild(trElement);
		// set click for plus icon
		$('#icon-plus' + current_id).click(function() {
			// false --> do not create plus button anymore
			addNewFilter(false);
		});
		// set click for minus icon
		$('#icon-minus' + current_id).click(function() {
			available_ids.splice(available_ids.indexOf(current_id), 1);
			trElement.remove();
		});
		// update max id
		max_id ++;
	}

	// Add the first filter row
	addNewFilter(true);

	// set filter button
	$('#filterButton').click(function() {
		var conditions = [];
		$.each(available_ids, function(index, id){
			conditions.push({
				category: $('#categorySelect' + id).val(),
				condition: $('#conditionSelect' + id).val(),
				star: $('#starSelect' + id).val(),
			});
		});
		// send request to the server and update display
		$('#container').remove();
		$.getJSON(
			'/users/' + <%= @user.id %> + '/filterfriends',
			{ filter_conditions: JSON.stringify(conditions) },
			function (data) {
				var container = document.createElement('div');
				container.setAttribute('id', 'container');
				container.setAttribute('class', 'clearfix');
				document.getElementById('container1').appendChild(container);

				var count = 0;
				var rowNumber = 4;
				var colNumber = 5;

				$.each(data, function(index, value) {

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

</script>