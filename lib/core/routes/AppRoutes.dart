enum AppRoutes {
  splash('/'),
  onboarding('/onboarding'),
  login('/login'),
  register('/register'),
  roleSelection('/role-selection'),

  // Student
  home('/home'),
  studentProfileSetup('/student-profile-setup'),
  studentProfile('/student-profile'),
  vocationalResults('/vocational-results'),
  careers('/careers'),
  careerDetail('/career-detail'),
  careerCompare('/career-compare'),
  universities('/universities'),
  universityDetail('/university-detail'),
  scholarships('/scholarships'),
  events('/events'),
  alumniList('/alumni-list'),
  favorites('/favorites'),
  requestSupport('/request-support'),
  vocationalRoute('/vocational-route'),
  studentAgenda('/student-agenda'),

  // Chat
  chat('/chat'),
  chatContacts('/chat-contacts'),
  realChat('/real-chat'),

  // Games
  games('/games'),
  gameDetail('/game-detail'),

  // Counselor
  counselorHome('/counselor-home'),
  counselorProfile('/counselor-profile'),
  vocationalMap('/vocational-map'),
  studentFile('/student-file'),
  groupStudents('/group-students'),

  // University
  universityHome('/university-home'),
  manageCareers('/manage-careers'),
  universityVerification('/university-verification'),
  manageEvents('/manage-events'),
  manageAnnouncements('/manage-announcements'),

  // Alumni
  alumniHome('/alumni-home'),
  alumniProfile('/alumni-profile'),
  successStories('/success-stories'),
  alumniProfileForm('/alumni-profile-form'),
  writeStory('/write-story'),

  // Admin
  adminHome('/admin-home'),
  adminUsers('/admin-users');

  final String path;

  const AppRoutes(this.path);
}
