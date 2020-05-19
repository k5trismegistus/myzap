# myzap

An app to tell me what to do now.


# image

<img src="https://github.com/k5trismegistus/myzap/blob/master/docs/images/Screenshot_20191031-225949.png" width="480">

<img src="https://github.com/k5trismegistus/myzap/blob/master/docs/images/Screenshot_20191031-225957.png" width="480">

# Roadmap

## V1.0.0

- Cover usage for single user.

## V2.0.0

- Support "Multi user task"

```
Idea:
Add task to each users's task list and record to whom added in other record

like this...
tasks: {
  user1: {
    tasks: [{ id: 111 }]
  },
  user2: {
    tasks: [{ id: 111 }]
  },
}

multitask: {
  111: {
    users: [user1, user2]
  }
}
```
