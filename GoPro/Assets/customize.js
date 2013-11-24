// JavaScript injected into the WebView for browsing GoPro files.

(function() {
    var logo = document.querySelector('.logo');

    // Re-purpose the logo to create a 'back to home' link.
    logo.onclick = function() { window.location = '/'; };
    logo.style.cursor = 'pointer';

    var listing, up;
    var dirlist = document.querySelector('#dirlist');

    // Extend the file list.
    if (dirlist && window.location.pathname !== '/') {
        listing = dirlist.querySelector('tbody');
        up = document.createElement('tr');

        up.innerHTML = [
            '<td><img class="icon" src="/icons/folder.png" alt="[DIR]"></td>',
            '<td><a href="..">..</a></td>',
            '<td></td>'
        ].join('');

        listing.insertBefore(up, listing.firstChild);
    }
})();
