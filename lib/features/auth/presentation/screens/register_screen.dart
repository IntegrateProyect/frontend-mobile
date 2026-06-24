import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  String? _selectedRole;
  final ScrollController _scrollController = ScrollController();

  // Consentimientos Paso 3
  bool _authPrivacy = false;
  bool _authSharing = false;

  // Controllers Step 1
  final _nameController = TextEditingController(text: 'Juan Pérez');
  final _ageController = TextEditingController(text: '16');
  final _schoolController = TextEditingController(text: 'Preparatoria Central');
  final _groupCodeController = TextEditingController(text: 'ORI-5B-2026');
  final _gradeController = TextEditingController(text: '5to B');
  final _emailController = TextEditingController(text: 'usuario@ejemplo.com');
  final _passwordController = TextEditingController();

  // State Step 2 (Student Profile)
  final List<String> _favoriteSubjects = ['Matemáticas', 'Biología', 'Diseño'];
  final List<String> _interests = ['Tecnología', 'Salud', 'Arte'];
  final List<String> _skills = ['Comunicación', 'Creatividad', 'Lógica'];
  final List<String> _careers = ['Ingeniería en Sistemas', 'Diseño Gráfico'];
  bool _needsScholarship = true;
  String _preferredModality = 'En línea';
  double _certaintyLevel = 3.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedRole = ModalRoute.of(context)?.settings.arguments as String? ?? 'student';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _schoolController.dispose();
    _groupCodeController.dispose();
    _gradeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTop());
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTop());
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isStudent = _selectedRole == 'student';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _prevStep,
        ),
        title: Text(
          isStudent ? 'Registro Estudiante' : 'Registro Orientador',
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Step Progress Indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
            child: Row(
              children: [
                _buildStepCircle(icon: Icons.person, step: 0),
                _buildStepLine(step: 0),
                _buildStepCircle(icon: Icons.menu_book, step: 1),
                _buildStepLine(step: 1),
                _buildStepCircle(icon: Icons.check, step: 2),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Center(child: _buildStepLabel('Cuenta', 0))),
                Expanded(child: Center(child: _buildStepLabel('Perfil', 1))),
                Expanded(child: Center(child: _buildStepLabel('Finalizar', 2))),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildCurrentStepContent(),
            ),
          ),
          
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0: return _buildStepAccount();
      case 1: return _buildStepCompleteProfile();
      case 2: return _buildStepFinalize();
      default: return const SizedBox.shrink();
    }
  }

  // --- PASO 1 ---
  Widget _buildStepAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Crea tu cuenta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B))),
        const SizedBox(height: 8),
        const Text('Comienza tu viaje hacia el éxito profesional hoy mismo.', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 32),

        _buildSectionHeader('DATOS PERSONALES', Icons.person_outline),
        _buildInputField(label: 'Nombre Completo', hint: 'Ej. Juan Pérez', icon: Icons.person_outline, controller: _nameController),
        const SizedBox(height: 16),
        _buildInputField(label: 'Edad', hint: '16', icon: Icons.calendar_today_outlined, controller: _ageController),
        const SizedBox(height: 24),

        _buildSectionHeader('INFORMACIÓN ACADÉMICA', Icons.school_outlined),
        _buildInputField(label: 'Institución Educativa', hint: 'Nombre de tu escuela', icon: Icons.business_outlined, controller: _schoolController),
        const SizedBox(height: 16),
        _buildInputField(label: 'Codigo del Grupo', hint: 'Ej. 01546', icon: Icons.menu_book_outlined, controller: _groupCodeController),
        const SizedBox(height: 24),

        _buildSectionHeader('SEGURIDAD', Icons.lock_outline),
        _buildInputField(label: 'Correo Electrónico', hint: 'usuario@ejemplo.com', icon: Icons.email_outlined, controller: _emailController),
        const SizedBox(height: 16),
        _buildInputField(
          label: 'Contraseña', 
          hint: 'Minimo 8 caracteres', 
          icon: Icons.lock_outline, 
          isPassword: _obscurePassword,
          controller: _passwordController,
          suffix: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: Colors.grey),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Checkbox(
              value: _acceptTerms,
              onChanged: (val) => setState(() => _acceptTerms = val ?? false),
              activeColor: const Color(0xFF311B92),
            ),
            const Expanded(
              child: Text('Acepto los Términos y Condiciones así como la Política de Privacidad.', style: TextStyle(fontSize: 12, color: Colors.black87)),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // --- PASO 2 ---
  Widget _buildStepCompleteProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Completa tu perfil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B))),
        const SizedBox(height: 8),
        const Text('Cuéntanos más sobre ti para personalizar tu experiencia.', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),

        _buildAccountSummaryCard(),

        const SizedBox(height: 24),
        _buildChipSection('Materias favoritas', _favoriteSubjects, Icons.star_border),
        _buildChipSection('Intereses', _interests, Icons.favorite_border),
        _buildChipSection('Habilidades', _skills, Icons.bolt),
        _buildChipSection('Carreras consideradas', _careers, Icons.work_outline),

        const SizedBox(height: 16),
        _buildToggleField('¿Necesitas beca?', ['Si', 'No'], _needsScholarship ? 'Si' : 'No', (v) => setState(() => _needsScholarship = v == 'Si')),
        const SizedBox(height: 16),
        _buildToggleField('Modalidad preferida', ['Presencial', 'En línea', 'Mixta'], _preferredModality, (v) => setState(() => _preferredModality = v)),
        
        const SizedBox(height: 24),
        _buildSecuritySlider(),
        const SizedBox(height: 40),
      ],
    );
  }

  // --- PASO 3 ---
  Widget _buildStepFinalize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Finaliza tu registro', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B))),
        const SizedBox(height: 8),
        const Text('Revisa tu información y confirma para crear tu cuenta.', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[100]!)),
          child: Column(
            children: [
              _buildFinalSummaryRow(Icons.description_outlined, 'Resumen final', '', isHeader: true),
              const SizedBox(height: 12),
              _buildFinalSummaryRow(Icons.person_outline, 'Nombre', _nameController.text),
              _buildFinalSummaryRow(Icons.calendar_today_outlined, 'Edad', _ageController.text),
              _buildFinalSummaryRow(Icons.account_balance_outlined, 'Escuela', _schoolController.text),
              _buildFinalSummaryRow(Icons.book_outlined, 'Grado / Grupo', _gradeController.text),
              _buildFinalSummaryRow(Icons.people_outline, 'Código de grupo', _groupCodeController.text),
              _buildFinalSummaryRow(Icons.email_outlined, 'Correo', _emailController.text),
              _buildFinalSummaryRow(Icons.star_border, 'Materias', _favoriteSubjects.join(', ')),
              _buildFinalSummaryRow(Icons.verified_user_outlined, 'Seguridad', '${_certaintyLevel.round()}/5'),
            ],
          ),
        ),

        const SizedBox(height: 24),
        _buildSectionHeader('Consentimientos', Icons.verified_user_outlined),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _buildConsentRow('Autorizo el tratamiento de mis datos personales.', _authPrivacy, (val) => setState(() => _authPrivacy = val!)),
              const Divider(height: 1),
              _buildConsentRow('Autorizo compartir mi información con mi orientador.', _authSharing, (val) => setState(() => _authSharing = val!)),
            ],
          ),
        ),

        const SizedBox(height: 24),
        _buildSectionHeader('Antes de continuar', Icons.assignment_turned_in_outlined),
        Column(
          children: [
            _buildCheckItem('Tus datos de cuenta están completos'),
            _buildCheckItem('Tu perfil vocacional inicial fue capturado'),
            _buildCheckItem('Te unirás al grupo de tu orientador automáticamente'),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF311B92)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(color: Color(0xFF311B92), fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildInputField({required String label, required String hint, required IconData icon, bool isPassword = false, Widget? suffix, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B))),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, size: 18, color: Colors.grey[600]),
            suffixIcon: suffix,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleField(String title, List<String> options, String current, Function(String) onSelect) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(title.contains('beca') ? Icons.school_outlined : Icons.computer_outlined, size: 18, color: const Color(0xFF311B92)),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1D1B4B)))),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: options.map((opt) {
                bool isSelected = opt == current;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onSelect(opt),
                    child: Container(
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFF5F3FF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected ? Border.all(color: const Color(0xFFDDD6FE)) : null,
                      ),
                      child: Text(opt, 
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11, 
                          color: isSelected ? const Color(0xFF311B92) : Colors.grey[600], 
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                        )
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[100]!))),
      child: Column(
        children: [
          Row(
            children: [
              if (_currentStep > 0) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _prevStep,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFF311B92))),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Volver', style: TextStyle(color: Color(0xFF311B92), fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: (_currentStep == 0 && !_acceptTerms) ? null : _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF311B92),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_currentStep == 0 ? 'Registrarse' : (_currentStep == 1 ? 'Continuar' : 'Crear cuenta'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_currentStep == 0) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿Ya tienes una cuenta? ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Inicia sesión', style: TextStyle(color: Color(0xFF311B92), fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // --- OTROS WIDGETS ---
  Widget _buildStepCircle({required IconData icon, required int step}) {
    bool isCompleted = _currentStep > step;
    bool isActive = _currentStep == step;
    Color color = (isActive || isCompleted) ? const Color(0xFF311B92) : Colors.grey[300]!;
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(color: isCompleted ? const Color(0xFF311B92) : Colors.white, shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
      child: Icon(isCompleted ? Icons.check : icon, size: 18, color: isCompleted ? Colors.white : color),
    );
  }

  Widget _buildStepLine({required int step}) {
    bool isCompleted = _currentStep > step;
    return Expanded(child: Container(height: 2, color: isCompleted ? const Color(0xFF311B92) : Colors.grey[200]));
  }

  Widget _buildStepLabel(String label, int step) {
    bool isActive = _currentStep == step;
    return Text(label, style: TextStyle(color: isActive ? const Color(0xFF311B92) : Colors.grey, fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.normal));
  }

  Widget _buildAccountSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[100]!), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: Column(
        children: [
          Row(children: [const Icon(Icons.person_outline, size: 18, color: Color(0xFF311B92)), const SizedBox(width: 8), const Text('Resumen de tu cuenta', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D1B4B)))]),
          const SizedBox(height: 16),
          Row(children: [Expanded(child: _buildSummaryField('Nombre', _nameController.text)), Expanded(child: _buildSummaryField('Grado', _gradeController.text))]),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: _buildSummaryField('Edad', _ageController.text)), Expanded(child: _buildSummaryField('Código', _groupCodeController.text))]),
        ],
      ),
    );
  }

  Widget _buildSummaryField(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)), Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)]);
  }

  Widget _buildChipSection(String title, List<String> items, IconData icon) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, size: 18, color: const Color(0xFF311B92)), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: [...items.map((item) => Chip(label: Text(item, style: const TextStyle(fontSize: 11)), backgroundColor: const Color(0xFFF5F3FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none))), ActionChip(label: const Text('+ Agregar', style: TextStyle(fontSize: 11)), onPressed: () {})]),
      const SizedBox(height: 20),
    ]);
  }

  Widget _buildSecuritySlider() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Icon(Icons.verified_user_outlined, size: 18, color: Color(0xFF311B92)), const SizedBox(width: 8), const Text('Nivel de seguridad', style: TextStyle(fontWeight: FontWeight.bold))]),
      Slider(value: _certaintyLevel, min: 1, max: 5, divisions: 4, label: _certaintyLevel.round().toString(), activeColor: const Color(0xFF311B92), onChanged: (v) => setState(() => _certaintyLevel = v)),
    ]);
  }

  Widget _buildFinalSummaryRow(IconData icon, String label, String value, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6), 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey), 
          const SizedBox(width: 12), 
          Expanded(flex: 3, child: Text(label, style: TextStyle(fontSize: 12, fontWeight: isHeader ? FontWeight.bold : FontWeight.normal))), 
          if (!isHeader) Expanded(flex: 4, child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))
        ]
      )
    );
  }

  Widget _buildConsentRow(String text, bool value, Function(bool?) onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24, width: 24, child: Checkbox(value: value, onChanged: onChanged, activeColor: const Color(0xFF311B92), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 12, height: 1.4))),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.check_circle_outline, color: Colors.green, size: 18), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)))]),
    );
  }
}
