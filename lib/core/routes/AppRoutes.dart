enum AppRoutes {
  splash('/'),
  onboarding('/onboarding'),
  login('/login'),
  register('/register'),
  roleSelection('/role-selection'),
  
  // Student
  home('/home'),
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

  // Chat
  chat('/chat'), // Chatbot
  chatContacts('/chat-contacts'),
  realChat('/real-chat'),

  // Games
  games('/games'),
  gameDetail('/game-detail'),

  // Counselor
  counselorHome('/counselor-home'),
  counselorProfile('/counselor-profile'),
  vocationalMap('/vocational-map'),

  // University Institution
  universityHome('/university-home'),
  manageCareers('/manage-careers'),

  // Alumni (Egresado)
  alumniHome('/alumni-home'),
  alumniProfile('/alumni-profile'),

  // Admin
  adminHome('/admin-home'),
  adminUsers('/admin-users');

  final String path;
  const AppRoutes(this.path);
}
