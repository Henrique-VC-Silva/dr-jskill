# Front-End Development for Spring Boot Applications

## Overview
This guide covers creating front-end websites for Spring Boot applications using vanilla JavaScript and Bootstrap, following best practices for static resource organization.

## Front-End Location
Spring Boot serves static content from the following locations in the classpath:
- `src/main/resources/static/` (recommended for static web assets)
- `src/main/resources/public/`
- `src/main/resources/resources/`
- `src/main/resources/META-INF/resources/`

**Best Practice**: Use `src/main/resources/static/` as the primary location for all front-end assets.

## Standard Folder Structure
```
my-spring-boot-app/
├── src/
│   └── main/
│       └── resources/
│           └── static/           # Root for all static web content
│               ├── index.html    # Main entry point
│               ├── css/
│               │   └── styles.css
│               ├── js/
│               │   └── app.js
│               ├── images/
│               └── favicon.ico
```

## Technologies
- **HTML5**: Semantic markup
- **Vanilla JavaScript**: No frameworks (ES6+)
- **Bootstrap 5.3.x**: Latest stable version for responsive design
- **CSS3**: Custom styling

## Getting Started

### 1. Basic HTML Template (index.html)
Create `src/main/resources/static/index.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Spring Boot Application</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" 
          rel="stylesheet" 
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" 
          crossorigin="anonymous">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="/css/styles.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="/">My Spring Boot App</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
                    data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/about.html">About</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="container my-5">
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <h1 class="display-4">Welcome to Spring Boot</h1>
                <p class="lead">A modern web application built with Spring Boot and vanilla JavaScript.</p>
                
                <div id="app-content">
                    <!-- Dynamic content will be loaded here -->
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-light py-4 mt-auto">
        <div class="container text-center">
            <p class="text-muted mb-0">&copy; 2026 Spring Boot Application</p>
        </div>
    </footer>

    <!-- Bootstrap JavaScript Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" 
            crossorigin="anonymous"></script>
    
    <!-- Custom JavaScript -->
    <script src="/js/app.js"></script>
</body>
</html>
```

### 2. Custom Styling (css/styles.css)
Create `src/main/resources/static/css/styles.css`:

```css
/* Custom styles for your Spring Boot application */
:root {
    --primary-color: #0d6efd;
    --secondary-color: #6c757d;
}

body {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

main {
    flex: 1;
}

.navbar-brand {
    font-weight: 600;
}

/* Add your custom styles below */
```

### 3. JavaScript Application (js/app.js)
Create `src/main/resources/static/js/app.js`:

```javascript
// Modern vanilla JavaScript for Spring Boot application
'use strict';

// API base URL (adjust for your Spring Boot backend)
const API_BASE_URL = '/api';

/**
 * Utility function to make HTTP requests
 * @param {string} url - The API endpoint
 * @param {object} options - Fetch options
 * @returns {Promise} - Response data
 */
async function fetchData(url, options = {}) {
    try {
        const response = await fetch(url, {
            headers: {
                'Content-Type': 'application/json',
                ...options.headers
            },
            ...options
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        return await response.json();
    } catch (error) {
        console.error('Fetch error:', error);
        throw error;
    }
}

/**
 * Initialize the application
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('Application initialized');
    
    // Example: Load data from your Spring Boot backend
    loadContent();
    
    // Setup event listeners
    setupEventListeners();
});

/**
 * Load content from the backend
 */
async function loadContent() {
    const contentDiv = document.getElementById('app-content');
    
    try {
        // Example API call - adjust to your actual endpoint
        // const data = await fetchData(`${API_BASE_URL}/data`);
        
        // For now, display a welcome message
        contentDiv.innerHTML = `
            <div class="card mt-4">
                <div class="card-body">
                    <h5 class="card-title">Getting Started</h5>
                    <p class="card-text">
                        Your Spring Boot application is running! 
                        Connect this front-end to your REST API endpoints.
                    </p>
                    <button class="btn btn-primary" id="testBtn">Test Button</button>
                </div>
            </div>
        `;
        
        // Re-setup listeners for newly added elements
        setupDynamicEventListeners();
    } catch (error) {
        contentDiv.innerHTML = `
            <div class="alert alert-danger" role="alert">
                Error loading content: ${error.message}
            </div>
        `;
    }
}

/**
 * Setup event listeners
 */
function setupEventListeners() {
    // Add your global event listeners here
}

/**
 * Setup event listeners for dynamically added elements
 */
function setupDynamicEventListeners() {
    const testBtn = document.getElementById('testBtn');
    if (testBtn) {
        testBtn.addEventListener('click', function() {
            alert('Button clicked! Connect to your Spring Boot backend.');
        });
    }
}

/**
 * Example: POST request to backend
 * @param {object} data - Data to send
 */
async function postData(data) {
    return await fetchData(`${API_BASE_URL}/endpoint`, {
        method: 'POST',
        body: JSON.stringify(data)
    });
}

/**
 * Example: Handle form submission
 * @param {Event} event - Form submit event
 */
async function handleFormSubmit(event) {
    event.preventDefault();
    
    const formData = new FormData(event.target);
    const data = Object.fromEntries(formData.entries());
    
    try {
        const result = await postData(data);
        console.log('Success:', result);
        // Update UI with result
    } catch (error) {
        console.error('Error:', error);
        // Show error message to user
    }
}
```

## Best Practices

### 1. Static Resource Organization
- Keep HTML files in the root of `static/`
- Organize CSS files in `static/css/`
- Organize JavaScript files in `static/js/`
- Store images in `static/images/`
- Use meaningful file and folder names

### 2. Bootstrap Usage
- **Always use the latest stable version** (currently 5.3.3)
- Include both CSS and JavaScript bundle via CDN
- Use Bootstrap's utility classes for rapid prototyping
- Override Bootstrap variables with custom CSS when needed
- Leverage Bootstrap's grid system for responsive layouts

### 3. Vanilla JavaScript Best Practices
- Use ES6+ features (arrow functions, async/await, const/let)
- Implement proper error handling
- Use `fetch` API for HTTP requests
- Wait for DOM to load with `DOMContentLoaded`
- Keep code modular and well-commented
- Avoid global variables when possible
- Use strict mode (`'use strict';`)

### 4. API Integration
- Create reusable fetch utilities
- Handle errors gracefully with user feedback
- Use async/await for cleaner asynchronous code
- Implement proper loading states
- Add request/response interceptors if needed

### 5. Security Considerations
- Never expose sensitive data in client-side code
- Implement CSRF protection (Spring Security handles this)
- Validate all user inputs
- Use HTTPS in production
- Sanitize data before rendering in the DOM

### 6. Performance
- Minimize HTTP requests
- Use CDN for Bootstrap and other libraries
- Implement lazy loading for images
- Minify CSS and JavaScript for production
- Use browser caching appropriately

## Spring Boot Configuration

### Serving Static Content
Spring Boot automatically serves static content without additional configuration. Files in `src/main/resources/static/` are accessible at the root path.

Example URLs:
- `http://localhost:8080/` → `static/index.html`
- `http://localhost:8080/css/styles.css` → `static/css/styles.css`
- `http://localhost:8080/js/app.js` → `static/js/app.js`

### Custom Configuration (if needed)
In `application.properties`:

```properties
# Customize static resource locations (optional)
spring.web.resources.static-locations=classpath:/static/

# Cache control for static resources
spring.web.resources.cache.cachecontrol.max-age=3600
```

## Connecting to REST API

### Example Controller (Java)
```java
@RestController
@RequestMapping("/api")
public class DataController {
    
    @GetMapping("/data")
    public ResponseEntity<List<Item>> getData() {
        // Your business logic
        return ResponseEntity.ok(items);
    }
    
    @PostMapping("/data")
    public ResponseEntity<Item> createData(@RequestBody Item item) {
        // Your business logic
        return ResponseEntity.ok(createdItem);
    }
}
```

### Accessing from JavaScript
```javascript
// GET request
const items = await fetchData('/api/data');

// POST request
const newItem = await postData({ name: 'Item Name', value: 100 });
```

## Additional Pages

### About Page Example
Create `src/main/resources/static/about.html` following the same structure as `index.html`.

## Testing Your Front-End

1. **Run your Spring Boot application**:
   ```bash
   ./mvnw spring-boot:run
   ```

2. **Access your front-end**:
   - Navigate to `http://localhost:8080/`
   - Static files are automatically served

3. **Browser DevTools**:
   - Use Console for JavaScript debugging
   - Use Network tab to monitor API calls
   - Use Elements tab to inspect HTML/CSS

## Resources
- [Bootstrap 5.3 Documentation](https://getbootstrap.com/docs/5.3/)
- [MDN Web Docs - JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
- [Spring Boot Static Content](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#web.servlet.spring-mvc.static-content)
- [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API)
