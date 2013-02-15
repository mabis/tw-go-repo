# tw-go-repo

apt and yum repositories for ThoughtWorks Go.

> But there is a limit to what we can do, and it will never be as simple as apt-get install because we'll never get into the upstream distros because we're not OSS.

## How?

### Use apt?

```shell
$ cat /etc/apt/sources.list.d/go.list 
deb http://tw-go-repo.quadhome.com/ go main

$ apt-get install --force-yes -yqq go-agent
```

### Use yum?

```shell
$ cat > /etc/yum.repos.d/go.repo 
[go]
name=ThoughtWorks Go
baseurl=http://tw-go-repo.quadhome.com/
enabled=1
gpgcheck=0

$ yum install -qy go-agent
```

## Thanks!

You're welcome!

### ... but why?

Because not having automation-accessible packages for your Continuous Delivery tool is some serious cognitive dissonance.

### Oh, well why not?

> As long as people don't start installing Go with 50 users
and 200 agents for free on customers sites but that's possible even
today, it's just more of a PITA :-)

No, wait. That would be *great*. See: Windows.

> Having said that there are still other things we need to work on and
need to strike the right balance: I do want people to have to give me
their email address, if not for downloading (since, as written above,
Go would run but not allow remote agents) the moment they request a
community licence. Why? because we are a 3-pillar company, not a
pillar 3 company and if I don't have a way to get in touch with and
nurture potential customers I have a problem.

More than 20 users? More than 10 agents? [$12,500 please](http://www.thoughtworks-studios.com/go-continuous-delivery/contact-sales) and do mention me in the referral form.
