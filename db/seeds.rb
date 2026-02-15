Framework.create!([
  { code: "ISO 27001:2022", description: "Globally recognized best practice framework", name: "Information Security Management System", version: "2022" },
  { code: "PCIDSSv4", description: "Globally recognized best practice framework", name: "Payment Card International Data Standard Security", version: "4.0.1" }
])
Control.create!([
  { category: "Preventive Controls", code: "DESC 1", description: "A documented and formally approved document policy", domain: "Access Management", name: "Access Control Policy", question: "Is there a documented, approved access control policy within the organization?" },
  { category: "Security Operations", code: "DESC 2", description: "adjaksd dajdhkdj ashdjkhakjdas dajkdahsdiaudioahd98wiweur3hqi", domain: "Access Manageemnt", name: "Multi-factor Authentication", question: "Is MFA implemented on all systems and application used within the Bank?" }
])
Account.create!([
  { name: "39e38317f6f4" }
])
User.create!([
  { account_id: 1, email_address: "idawills.iw@gmail.com", name: "William Idakwo", password_digest: "$2a$12$xFF5gn.uc5XMKStAfxi1V.WdND9tPjMKRkAKcINCJgFeg7EM/A8lC", role: "owner", country: nil, active: true, force_password_reset: nil },
  { account_id: 1, email_address: "oajayi@deloitte.com.ng", name: "Oluwabunmi Ajayi", password_digest: "$2a$12$vOIgbJDNn8Qy9pEOl.3tE.QPPu0ctTj/5daeKv1CfBC2nR2YGkFW.", role: "member", country: "Nigeria", active: true, force_password_reset: nil },
  { account_id: 1, email_address: "conuoha@deloitte.com", name: "Chukwuebuka Onuoha", password_digest: "$2a$12$qtv0gMaen5QMdOPLbiZiY.YgejeFpLqm4t7NhXZJS.BzUbT1Tuct.", role: "assessor", country: "NG", active: true, force_password_reset: nil }
])
Team.create!([
  { name: "Head Office", account_id: 1 },
  { name: "Cameroun", account_id: 1 }
])
FrameworkControl.create!([
  { code: "A.5.4.1", control_id: 1, description: nil, framework_id: 1, guidance: nil, name: nil, section: nil },
  { code: "8.2.3", control_id: 2, description: nil, framework_id: 2, guidance: nil, name: nil, section: nil }
])
TeamUser.create!([
  { user_id: 1, team_id: 1 },
  { user_id: 2, team_id: 2 },
  { user_id: 2, team_id: 1 },
  { user_id: 3, team_id: 1 },
  { user_id: 3, team_id: 2 }
])
Session.create!([
  { ip_address: "::1", user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36", user_id: 1 },
  { ip_address: "::1", user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36", user_id: 3 },
  { ip_address: "::1", user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36", user_id: 2 },
  { ip_address: "127.0.0.1", user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0", user_id: 1 },
  { ip_address: "127.0.0.1", user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:147.0) Gecko/20100101 Firefox/147.0", user_id: 2 },
  { ip_address: "::1", user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36", user_id: 2 }
])
MagicLink.create!([
  { code: "WRPRF0", expires_at: "2026-01-03T14:02:33Z", purpose: nil, user_id: 1 },
  { code: "GBMQF8", expires_at: "2026-01-03T14:08:57Z", purpose: nil, user_id: 1 },
  { code: "PS6X9R", expires_at: "2026-01-04T10:01:59Z", purpose: nil, user_id: 1 },
  { code: "EN7WEW", expires_at: "2026-01-10T18:04:43Z", purpose: nil, user_id: 1 },
  { code: "S5X52A", expires_at: "2026-01-10T18:19:24Z", purpose: nil, user_id: 1 },
  { code: "A095KR", expires_at: "2026-01-11T13:33:38Z", purpose: nil, user_id: 1 },
  { code: "EKHZJ0", expires_at: "2026-01-11T13:34:38Z", purpose: nil, user_id: 1 },
  { code: "595MHC", expires_at: "2026-01-15T19:50:50Z", purpose: nil, user_id: 3 },
  { code: "EYKEV5", expires_at: "2026-01-16T10:29:07Z", purpose: nil, user_id: 2 },
  { code: "1Z5B0T", expires_at: "2026-01-18T23:22:50Z", purpose: nil, user_id: 1 },
  { code: "PSG0SZ", expires_at: "2026-01-18T23:23:29Z", purpose: nil, user_id: 1 }
])
Assessment.create!([
  { user_id: 1, name: "2026 Annual Information Security Risk Assessment", status: "open", due_date: nil, version: nil, account_id: 1, team_id: 1 },
  { user_id: 1, name: "Satire", status: "open", due_date: "2026-01-25", version: nil, account_id: 1, team_id: 1 },
  { user_id: 1, name: "Remider 2026", status: "open", due_date: "2026-01-30", version: nil, account_id: 1, team_id: 1 },
  { user_id: 2, name: "2027 Integrated Management System", status: "open", due_date: nil, version: nil, account_id: 1, team_id: 2 },
  { user_id: 2, name: "Cameroun 2028 Integrated Management System Assessment", status: "open", due_date: "2026-05-31", version: nil, account_id: nil, team_id: 2 }
])
AssessmentFramework.create!([
  { assessment_id: 1, framework_id: 1 },
  { assessment_id: 1, framework_id: 2 },
  { assessment_id: 2, framework_id: 1 },
  { assessment_id: 2, framework_id: 2 },
  { assessment_id: 3, framework_id: 1 },
  { assessment_id: 14, framework_id: 1 },
  { assessment_id: 14, framework_id: 2 }
])
Answer.create!([
  { comment: "The core banking application had MFA enabled on it.", control_id: 1, status: "C", user_id: 2, assessment_id: 1, url: "", state: "draft" },
  { comment: "afdfs\nsd\nf\nsdf\ns\nfsd\nfs", control_id: 2, status: "C", user_id: 2, assessment_id: 2, url: "", state: "draft" },
  { comment: "Just to prevent errors now", control_id: 2, status: "OFI", user_id: 2, assessment_id: 3, url: nil, state: "draft" },
  { comment: "Partially known joiun", control_id: 1, status: "OFI", user_id: 2, assessment_id: 13, url: "http://sharepoint/microsoft/uiwiwqebd8780odji23ld/teams/2/assessments/13", state: "draft" },
  { comment: "Part time scheduling time", control_id: 1, status: "C", user_id: 2, assessment_id: 3, url: "https://changelog.com/shared/income", state: "submitted" },
  { comment: "dddfffdmkl", control_id: 1, status: "NA", user_id: 2, assessment_id: 14, url: "", state: "draft" },
  { comment: "30 software applicatons were reviewed for authentication mechanisms (password +  2FA).\n\nThese applications include\n1. Purdue\n2. Laurent\n3. Procure\n4. Laminate\n5. Excali\n6. Detrust\n7. Packing\n8. Attacking\n9. Cardio\n10. Frinedly", control_id: 2, status: "C", user_id: 2, assessment_id: 14, url: "https://williamidakwo.com", state: "draft" },
  { comment: "", control_id: 2, status: "NC", user_id: 2, assessment_id: 1, url: "", state: "draft" }
])
