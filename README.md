### [Live demo](http://prettyizer.herokuapp.com)

# Description
Was made for the [hackathon organized by Typeform I/O](http://fullstackfest.com/agenda/full-stack-hack) during the [Full Stack Fest 2015](http://fullstackfest.com/).

This hack won "best by judges" award.

It converts ugly google forms to nice [typeforms](http://typeform.io). You get a link to the typeform representation of the google form.

Before: https://docs.google.com/forms/d/1rm2SkXQhQiyURW-mO-3zY0COBm7us-dR0tHcP5q9l-o/viewform?c=0&w=1

After: https://forms.typeform.io/to/636jqBwugs

# Setup
### Env variables
1. Set `APP_DOMAIN` to point to the public domain of the application. Example: "http://prettyizer.herokuapp.com". It's used as a webhook for the typeform API.
2. Set `TYPEFORM_API_TOKEN` to your typeform api token.

### Run
Just type `rackup` in the app directory.
