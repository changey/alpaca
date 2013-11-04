<script type = "text/javascript" > 
$(function() {

I18n.locale = "<%= I18n.locale %>";

var profile_id = "<%= @profile.id %>";
var id = "<%= session[:user_id] %>";
var categories = ['EQ'];
var ratingsTable = document.getElementById('ratings');

$.each(categories, function(index, category) {
	// create dom objects
	var trElement = document.createElement('tr');
	var nameTdElement = document.createElement('td');
	nameTdElement.appendChild(document.createTextNode(I18n.t(category)));
	trElement.appendChild(nameTdElement);
	var starTdElement = document.createElement('td');
	starTdElement.setAttribute('id', 'td' + 'star' + category);
	var starDivElement = document.createElement('div');
	starDivElement.setAttribute('id', 'star' + category);
	starTdElement.appendChild(starDivElement);
	trElement.appendChild(starTdElement);
	ratingsTable.appendChild(trElement);
	var userTdElement = document.createElement('td');
	userTdElement.setAttribute('id', 'user' + category);
	userTdElement.appendChild(document.createTextNode(''));
	trElement.appendChild(userTdElement);
	var totalTdElement = document.createElement('td');
	totalTdElement.setAttribute('id', 'total' + category);
	totalTdElement.appendChild(document.createTextNode(''));
	trElement.appendChild(totalTdElement);
	$('#star' + category).raty({
		cancel: 	true,
		half: 		true,
		hints: 		['bad', 'poor', 'regular', 'good', 'excellent'],
		mouseover: 	function(score, evt) {
			if (score !== undefined && score !== null) {
				userTdElement.firstChild.nodeValue = score;
			} else if (score === null) {
				userTdElement.firstChild.nodeValue = 'N/A';
			}
		},
	});
	starTdElement.style.width='130px';
	starDivElement.style.width='100%';
});

$.getJSON('/profiles/' + profile_id + '/getRatings', function(data) {
	$.each(categories, function(index, category) {
		update_rating(category, {
			'user': 	data['user'][category], 
			'total': 	data['total'][category]['total_ratings'], 
			'number': 	data['total'][category]['number_of_ratings']
		});
	});
});

function update_rating(category, data) {
	var userRating = data['user'];
	var totalRating = data['total'];
	var numberRating = data['number'];
	var avgRating, displayedAvg;
	if (numberRating != 0) {
		avgRating = totalRating / numberRating;
		displayedAvg = avgRating;
	} else {
		avgRating = 'N/A';
		displayedAvg = 0.0;
	}
	if (userRating === undefined) {
		userRating = 'N/A';
	}
	var starTdElement = document.getElementById('td' + 'star' + category);
	var starDivElement = document.getElementById('star' + category);

	// set descriptions
	var userTdElement = document.getElementById('user' + category);
	userTdElement.firstChild.nodeValue = userRating;
	var totalTdElement = document.getElementById('total' + category);
	totalTdElement.firstChild.nodeValue = avgRating + ' (' + numberRating + ' ratings)';
	$('#star' + category).raty({
		cancel: 	true,
		half:  		true,
		hints: 		['bad', 'poor', 'regular', 'good', 'excellent'],
		score: 		userRating,
		mouseover 	:function(score, evt) {
			if (score !== undefined && score !== null) {
				userTdElement.firstChild.nodeValue = score;
			} else if (score === null) {
				userTdElement.firstChild.nodeValue = 'N/A';
			} else {
				userTdElement.firstChild.nodeValue = userRating;
			}
		},
		click	:function(score, evt) {
			if (score === null) {
				if (userRating !== 'N/A') {
					// delete the existing rating
					$.ajax({
						type: 		'DELETE',
						url: 		'/profiles/' + profile_id + '/ratings.json',
						data: 		{
							categ: 	category
						},
						success: 	function (data) {
							update_rating(category, data)
						}
					});
				}
			} else {
				if (userRating !== 'N/A') {
					// update the existing rating
					$.ajax({
						type: 		'PUT',
						url: 		'/profiles/' + profile_id + '/ratings.json',
						data: 		{
							categ: 	category,
							rate: 	score
						},
						success: 	function (data) {
							update_rating(category, data)
						}
					});
				} else {
					// create a new rating
					$.ajax({
						type: 		'POST',
						url: 		'/profiles/' + profile_id + '/ratings.json',
						data: 		{
							categ: 	category,
							rate: 	score
						},
						success: 	function (data) {
							update_rating(category, data)
						}
					});
				}
			}
		}
	})
	starTdElement.style.width='130px';
	starDivElement.style.width='100%';
}
});

</script>