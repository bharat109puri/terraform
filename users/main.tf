module "iam_users" {
  source = "../modules/iam_users"

  recrd_admins = [
    "csilla@recrd.com",
    "mate@recrd.com",
  ]

  recrd_developers = [
    "mate+developer@recrd.com",
  ]

  third_parties = {
    riltech = [
      "mate+riltech@gmail.com",
    ]
    rokk = []
  }
}