window.onload = function() {
    var filterTags = document.querySelectorAll("#filters .tag");
    for (var i = 0; i < filterTags.length; i++) {
        filterTags[i].addEventListener("click", function() {
            applyTagFilter(this.innerText);
        });
    }
}

function applyTagFilter(clickedTag) {
    var posts = document.getElementsByClassName("post");
    for (var i = 0; i < posts.length; i++) {
        var post = posts[i];
        var tags = post.getElementsByClassName("tag");
        var hasTag = false;
        for (var j = 0; j < tags.length; j++) {
            if (clickedTag == "(show all)" || tags[j].innerText == clickedTag) {
                hasTag = true;
            }
        }
        if (!hasTag) {
            post.style.display = "none";
        } else {
            post.style.display = "block";
        }
    }
}