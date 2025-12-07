# drop-baux 

the only distributed storage that doesn’t make you want to burn your house down, because it's SeaweedFS.

You tried NFS. Your Pi Zero cried.  
You tried Ceph. Your Pi Zero died.  
You tried Garage and realized you don’t actually need Rust that badly.

Now you run SeaweedFS and pretend it’s 1995 again, except it actually works.

```bash
# one node (any node, literally doesn’t matter)
weed master -port=9333 &

# every other node (yes, even the Pi Zero in the attic)
weed volume -dir=/drop-baux/vol -mserver=any-node:9333 -port=8080 &
weed filer  -dir=/drop-baux/filer -master=any-node:9333 -port=8888 &

# optional: make it feel like a real filesystem when you’re drunk
mkdir -p ~/drop-baux
weed mount -dir=~/drop-baux -filer=localhost:8888 &
