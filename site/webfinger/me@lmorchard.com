<?xml version='1.0'?>
<XRD xmlns='http://docs.oasis-open.org/ns/xri/xrd-1.0'>
	<Subject>acct:me@lmorchard.com</Subject>
	<Alias>http://lmorchard.com/</Alias>
	<Link rel='http://portablecontacts.net/spec/1.0' href='http://www-opensocial.googleusercontent.com/api/people/'/>
	<Link rel='http://portablecontacts.net/spec/1.0#me' href='http://www-opensocial.googleusercontent.com/api/people/114487965928288927815/'/>
	<Link rel='http://webfinger.net/rel/profile-page' href='http://www.google.com/profiles/l.m.orchard' type='text/html'/>
	<Link rel='http://microformats.org/profile/hcard' href='http://www.google.com/profiles/l.m.orchard' type='text/html'/>
	<Link rel='http://gmpg.org/xfn/11' href='http://www.google.com/profiles/l.m.orchard' type='text/html'/>
	<Link rel='http://specs.openid.net/auth/2.0/provider' href='http://www.google.com/profiles/l.m.orchard'/>
	<Link rel='describedby' href='http://www.google.com/profiles/l.m.orchard' type='text/html'/>
	<Link rel='describedby' href='http://www.google.com/s2/webfinger/?q=l.m.orchard%40gmail.com&amp;fmt=foaf' type='application/rdf+xml'/>
	<Link rel='http://schemas.google.com/g/2010#updates-from' href='https://www.googleapis.com/buzz/v1/activities/114487965928288927815/@public' type='application/atom+xml'/>
        <Link rel='remoteStorage'
            api='simple'
            auth='https://5apps.com/rs/oauth/lmorchard'
            template='https://5apps.com/storage/lmorchard/{category}/'>
        </Link>
</XRD>
