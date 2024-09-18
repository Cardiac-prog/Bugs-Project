document.addEventListener('DOMContentLoaded', () => {                    // This ensures that the script only runs after the entire HTML document has been loaded.
  const searchInput = document.getElementById('search-input');       // Finds the HTML element with the ID search-input i.e. the input field element
  const projectsList = document.getElementById('projects-list');     // Grabs the HTML element with the ID projects-list (a container for displaying search results)

  if (searchInput) {
    searchInput.addEventListener('input', () => {      // this will listen for any input in searchInput field. Everytime something is typed or remved in the input field, this event will be triggered
      const query = searchInput.value;            // It captures the current value of input field in query variable

      if (query.trim() === "") {              // After trimming the whitespaces, it checks whether the input is empty or not. If empty
        projectsList.innerHTML = '';          // It will clear the search result
        projectsList.style.display = 'none';   // and it will hide the projects list and then return the function without further execution
        return;
      }

      projectsList.style.display = 'block';      // when user enters valid query then it displays the project list

      fetch(`/projects.json?query=${query}`, {   // Sends a network request to /projects.json with the search query as a parameter
        headers: {
          'Accept': 'application/json',     // tells the server that client expects a JSON response
          'Cache-Control': 'no-cache'       // ensures that browser doesnot cache result, forcing fresh result everytime
        }
      })
        .then(response => {        // When a fetch request completes, it checks whether the response was ok or not
          if (!response.ok) {   // response.ok checks the HTTP status code
            throw new Error('Network response was not ok');
          }
          return response.json();   // converts response from server into JSON format
        })
        .then(data => {                   // After recieving data from server, this block processes it
          projectsList.innerHTML = '';  // clears any previous search results

          data.projects.forEach(project => {             // iterates over the array of objects returned by the server
            const listItem = document.createElement('li');    // creates a new li element to represent each project in the dropdown
            listItem.classList.add('dropdown-item');       // adds dropdown-item class to li element and this class will be used to style the dropdown element

            const link = document.createElement('a');    // creates an anchor element which will act as a clickable for the project
            link.href = project.url;                  // sets the href attribute of anchor element to the URL of project 
            link.textContent = project.title;       // sets the text inside anchor element to be the projects title
            listItem.appendChild(link);            // appends the the project link(link) to dropdown(ListItem)
            projectsList.appendChild(listItem);
          });
        })
        .catch(error => console.error('Error fetching data:', error));
    });

    document.addEventListener('click', (event) => {                // adds a global event listener. It is used to detect whether the user clicks outside the list
      if (!searchInput.contains(event.target) && !projectsList.contains(event.target)) {
        projectsList.style.display = 'none';              // if user clicked outside the dropdown then it will hide the dropdown list by setting its display to none
      }
    });
  }

  const bugSearchInput = document.getElementById('bug-search-input');
  const bugsList = document.getElementById('bugs-list');

  if (bugSearchInput) {
    bugSearchInput.addEventListener('input', () => {
      const query = bugSearchInput.value;

      if (query.trim() === "") {
        bugsList.innerHTML = ''; // Clear previous results
        bugsList.style.display = 'none'; // Hide list if no query
        return;
      }

      bugsList.style.display = 'block'; // Show list when query is valid

      fetch(`/bugs.json?query=${query}`, {
        headers: {
          'Accept': 'application/json',
          'Cache-Control': 'no-cache'
        }
      })
        .then(response => {
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          return response.json(); // Parse JSON
        })
        .then(data => {
          bugsList.innerHTML = ''; // Clear old results
          data.forEach(bug => {
            const listItem = document.createElement('li');
            const link = document.createElement('a');
            link.href = bug.url;
            link.textContent = bug.title;
            listItem.appendChild(link);
            bugsList.appendChild(listItem);
          });
        })
        .catch(error => console.error('Error fetching bugs:', error));
    });

    document.addEventListener('click', (event) => {
      if (!bugSearchInput.contains(event.target) && !bugsList.contains(event.target)) {
        bugsList.style.display = 'none'; // Hide dropdown if clicking outside
      }
    });
  }
});
