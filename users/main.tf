module "iam_users" {
  source = "../modules/iam_users"

  recrd_admins = [
    "csilla@recrd.com",
    "mate@recrd.com",
    "murali@recrd.com",
  ]

  recrd_developers = [
    "alex@recrd.com",
    "mate+developer@recrd.com",
  ]

  third_parties = {
    riltech = [
      "mate+riltech@gmail.com",
    ]
    rokk = []
  }
}
