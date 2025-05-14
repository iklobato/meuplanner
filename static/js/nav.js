document.addEventListener('DOMContentLoaded', function() {
  // Get current page filename
  const currentPage = window.location.pathname.split('/').pop() || 'mensal.html';
  
  // Highlight active navigation item
  const navLinks = document.querySelectorAll('.mcf-sidebar a');
  navLinks.forEach(link => {
    if (link.getAttribute('href') === currentPage) {
      link.classList.add('active');
    }
  });
  
  // Mobile menu toggle
  const mobileToggle = document.querySelector('.mcf-mobile-toggle');
  const sidebar = document.querySelector('.mcf-sidebar');
  
  if (mobileToggle && sidebar) {
    mobileToggle.addEventListener('click', function() {
      sidebar.classList.toggle('active');
    });
    
    // Close sidebar when clicking outside
    document.addEventListener('click', function(event) {
      if (!sidebar.contains(event.target) && 
          event.target !== mobileToggle && 
          !mobileToggle.contains(event.target) && 
          sidebar.classList.contains('active')) {
        sidebar.classList.remove('active');
      }
    });
  }
});
