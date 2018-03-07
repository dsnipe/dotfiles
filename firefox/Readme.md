# FireFox modifications

## userChrome.css
Put `userChrome.css` to `/Library/Application Support/FireFox/Profiles/<profile_name>/chrome`. Create `chrome` folder if it doesn't exist.

## TabCenter Redux Extension
Additional CSS:  
```
#newtab {
  display: none;
}
/* close button in the left on hover */
.tab:hover:not(.pinned) .tab-icon-wrapper {
  opacity: 0;
}
.tab-close {
    right: unset;
    left: 5px;
}
.tab:hover > .tab-title-wrapper::after {
  transform: translateX(36px);
}
/* end */
/* tab burst */
.tab-loading-burst {
  display: block;
}
/* end */
#tablist-wrapper {
border-left: 1px solid #e1e1e2;
}
```
