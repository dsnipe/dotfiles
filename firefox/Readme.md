## Todo
1. Copy `userChrome.css` to `\Library\Application Support\Firefox\profiles\<profile>\chrome\` (if folder `chrome` doesn't exist, create it). 
2. Paste CSS below in settings of Tab Center Redux extension

```css
.tab[notselectedsinceload="true"] {
  font-style: italic;
}
/* Plasma 5's Breeze */
body.dark-theme {
  --tab-background-normal: hsl(210, 9.289%, 21.045%);
  --tab-background-pinned: hsl(210, 9.289%, 21.045%);
  --tab-background-active: hsl(221, 41.4%, 53.1%);
  --tab-background-hover: hsl(222, 28.3%, 35.55%);
  --tab-border-color: hsla(0, 0%, 0%, 0.06);
  --menu-background: hsl(210, 9.289%, 21.045%);
}
#pinnedtablist {
  box-shadow: 0px 1px 0px hsla(0, 0%, 0%, 0.2);
  z-index: 1;
}
#pinnedtablist .tab:last-of-type {
  border-bottom: none;
}
#newtab {
  margin-left: -1px;
}
#newtab-icon {
  margin-right: 8px !important;
}
#searchbox {
  padding: 0px;
}
#newtab-label {
  margin-left: 0px;
}
#newtab-label.hidden {
  display: block !important;
  width: 0px;
  margin-right: -10px;
}
.tab-context {
  height: calc(100% + 1px);
  position: relative;
  top: 0.5px;
}
#pinnedtablist .tab:last-of-type .tab-context {
  height: 100%;
  top: 0px;
}

/* Loading burst */
.tab-loading-burst, .tab-loading-burst:before {
  display: block;
}
body.dark-theme .tab:not(.active) .tab-loading-burst.bursting::before {
  filter: invert(100%);
}

/* Hide close button */
.tab-close {
  left: -224px;
  }
```