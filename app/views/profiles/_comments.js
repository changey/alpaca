<script type="text/javascript">
    $(document).ready(function(){
    var url =  "/profiles/" + <%= @profile.id %> + "/comments.json"
        //the function used to add a new comment users typed to the existing comments
        $("#comment").click(function(){
        	//a post requst is used to send the comment users typed to the server
            $.post(
                    url,
                    { body:$("input:text").val() },
                    //the comment users typed is appended to the existing comments
                    function(r){
                          newComment(r)
                    }
            )
            $("input:text").val("")
        });
    });


// Send an ajax to update favorite
function clickFav(){
    var url = "../"+ <%= @profile.id %> + "/fav"
        $.post(url,
                {profile_id:<%= @profile.id %>},
                function(r){
                    //Update favorite button text
                    document.getElementById("favButton").setAttribute("value",r)
                }
        )
    }


  // send an upvote ajax given project id pid, comment id cid, and the vote counter element c
  function voteUp(pid, cid, c){
      var url = "../"+pid + "/vote.json"
      $.post(
              url,
              {comment_id:cid, up:true},
              function(r){
                  // update upvote counter
                    c.innerHTML= r.toString();
              }
      )
  }

// send an upvote ajax given project id pid, comment id cid, and the vote counter element c
    function voteDown(pid, cid, c){
      var url ="../"+ pid + "/vote.json"
      $.post(
              url,
              {comment_id:cid, up:false},
              function(r){
                // update downvote counter
                  c.innerHTML= r.toString();
              }
      )
  }

// DOM creation for a new comment; server response r contains commentor's user_id and the comment object
    function newComment(r){
        var user = r.uid
        var comment = r.comment
        var header = 'User '+ user + ': '

        // DOM hierarchy
        var trEl = document.createElement("tr")
        var tdEl = document.createElement("td")
        var tdEl1 = document.createElement("td")
        var tdEl2 = document.createElement("td")

        // Comment text
        tdEl.textContent= header+ comment.body

        // Upvote image
        var imgEl1 = document.createElement("img")
        imgEl1.setAttribute("src","/assets/thumbsup.png")
        imgEl1.setAttribute('width','30')
        imgEl1.setAttribute('height','30')
        imgEl1.setAttribute('onmouseover',"this.src='/assets/thumbsup_on.png'")
        imgEl1.setAttribute('onmouseout',"this.src='/assets/thumbsup.png'")
        imgEl1.setAttribute('onclick',"voteUp('<%= @profile.id %>','"+comment.id +"', this.nextElementSibling)")

        // Downvote image
    var imgEl2 = document.createElement("img")
        imgEl2.setAttribute("src","/assets/thumbsdown.png")
        imgEl2.setAttribute('width','30')
        imgEl2.setAttribute('height','30')
        imgEl2.setAttribute('onmouseover',"this.src='/assets/thumbsdown_on.png'")
        imgEl2.setAttribute('onmouseout',"this.src='/assets/thumbsdown.png'")
        imgEl2.setAttribute('onclick',"voteDown('<%= @profile.id %>','"+comment.id +"', this.nextElementSibling)")

        // Upvote and downvote counter
        var n1 = document.createElement("p");
        n1.textContent= 0
        var n2 = document.createElement("p");
        n2.textContent= 0

        // Assemble DOM elements
        tdEl1.appendChild(imgEl1)
        tdEl1.appendChild(n1)
        tdEl2.appendChild(imgEl2)
        tdEl2.appendChild(n2)
        trEl.appendChild(tdEl)
        trEl.appendChild(tdEl1)
        trEl.appendChild(tdEl2)

        document.getElementById("comments").appendChild(trEl)
    }

</script>




