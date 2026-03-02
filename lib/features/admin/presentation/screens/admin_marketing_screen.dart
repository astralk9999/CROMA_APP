import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_drawer.dart';
import '../../data/admin_repository.dart';

class AdminMarketingScreen extends ConsumerStatefulWidget {
  const AdminMarketingScreen({super.key});

  @override
  ConsumerState<AdminMarketingScreen> createState() =>
      _AdminMarketingScreenState();
}

class _AdminMarketingScreenState extends ConsumerState<AdminMarketingScreen> {
  final _subjectController = TextEditingController();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _showStock = false;
  String _selectedTemplate = 'NUEVO DROP';

  @override
  void dispose() {
    _subjectController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _executeCampaign() {
    if (_subjectController.text.isEmpty ||
        _titleController.text.isEmpty ||
        _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'REBOBINAR: Faltan campos clave para ejecutar.',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'LANZAMIENTO EJECUTADO: Procesando en cola externa.',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metricsAsync = ref.watch(adminMetricsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AdminAppBar(title: 'MARKETING Y CAMPAÑAS'),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Architecture
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                return isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderInfo(),
                          const SizedBox(height: 24),
                          metricsAsync.when(
                            data: (metrics) => _buildMetricsCard(
                              metrics['marketingReach']?.toString() ?? '0',
                              isFullWidth: true,
                            ),
                            loading: () =>
                                _buildMetricsCard('...', isFullWidth: true),
                            error: (_, __) =>
                                _buildMetricsCard('ERR', isFullWidth: true),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(child: _buildHeaderInfo()),
                          metricsAsync.when(
                            data: (metrics) => _buildMetricsCard(
                              metrics['marketingReach']?.toString() ?? '0',
                            ),
                            loading: () => _buildMetricsCard('...'),
                            error: (_, __) => _buildMetricsCard('ERR'),
                          ),
                        ],
                      );
              },
            ),
            const SizedBox(height: 48),

            // Main Editor Section Layout
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 900;
                return isMobile
                    ? Column(
                        children: [
                          _buildTemplatesSection(),
                          const SizedBox(height: 24),
                          _buildParamsSection(),
                          const SizedBox(height: 32),
                          _buildEditorSection(isMobile: true),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sidebar: Templates
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                _buildTemplatesSection(),
                                const SizedBox(height: 24),
                                _buildParamsSection(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          // Editor Central
                          Expanded(flex: 2, child: _buildEditorSection()),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
              ),
              child: const Text(
                'SISTEMA_ACTIVO',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'MARKETING\nHUB 2.0',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            height: 0.85,
            letterSpacing: -1,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        const Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            Icon(Icons.campaign, size: 16, color: Colors.black54),
            Text(
              'PROTOCOLO DE COMUNICACIÓN',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricsCard(String reach, {bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'AUDIENCIA',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                reach,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'ALCANCE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 4,
            width: isFullWidth ? double.infinity : 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.7,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 16, height: 2, color: Colors.black),
              const SizedBox(width: 8),
              const Text(
                '01. PLANTILLAS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _TemplateBtn(
            title: 'NUEVO DROP',
            subtitle: 'Lanzamiento Colección',
            isSelected: _selectedTemplate == 'NUEVO DROP',
            onTap: () => setState(() {
              _selectedTemplate = 'NUEVO DROP';
              _subjectController.text = 'NUEVO DROP DISPONIBLE 🏴';
              _titleController.text = 'THE FUTURE OF UTILITY';
              _bodyController.text =
                  'Descubre las nuevas prendas diseñadas para el movimiento diario.';
            }),
          ),
          const SizedBox(height: 12),
          _TemplateBtn(
            title: 'CÓDIGO SECRETO',
            subtitle: 'Cupón Descuento',
            isSelected: _selectedTemplate == 'CÓDIGO SECRETO',
            onTap: () => setState(() {
              _selectedTemplate = 'CÓDIGO SECRETO';
              _subjectController.text = 'TÚ CÓDIGO EXCLUSIVO 🔒';
              _titleController.text = 'RECOMPENSA ACUMULADA';
              _bodyController.text =
                  'Usa este código en tu próxima compra para activar tu descuento de fidelidad.';
            }),
          ),
          const SizedBox(height: 12),
          _TemplateBtn(
            title: 'RESTOCK',
            subtitle: 'Vuelta en Stock',
            isSelected: _selectedTemplate == 'RESTOCK',
            onTap: () => setState(() {
              _selectedTemplate = 'RESTOCK';
              _subjectController.text = 'HAN VUELTO 🔄';
              _titleController.text = 'RESTOCK CONFIRMADO';
              _bodyController.text =
                  'Las prendas más buscadas vuelven a estar disponibles. Cantidades limitadas.';
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildParamsSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 16, height: 2, color: Colors.grey[600]),
              const SizedBox(width: 8),
              const Text(
                '02. PARÁMETROS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ESTADO DE STOCK',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              Switch(
                value: _showStock,
                onChanged: (val) => setState(() => _showStock = val),
                activeThumbColor: Colors.greenAccent,
                inactiveTrackColor: Colors.grey[800],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Muestra indicadores de escasez en las prendas seleccionadas.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PERSONALIZACIÓN',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Usa {{name}} para insertar el nombre del cliente.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorSection({bool isMobile = false}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 32 : 40),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 01. Destinatarios
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '01. DESTINATARIOS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: 'subscribers',
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF4F4F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
            ),
            dropdownColor: const Color(0xFF18181B),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.black,
            ),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
            items: const [
              DropdownMenuItem(
                value: 'subscribers',
                child: Text('SUSCRIPTORES NEWSLETTER'),
              ),
              DropdownMenuItem(
                value: 'users',
                child: Text('USUARIOS REGISTRADOS'),
              ),
              DropdownMenuItem(value: 'all', child: Text('TRANSMISIÓN TOTAL')),
            ],
            onChanged: (val) {},
          ),
          const SizedBox(height: 32),

          // 02. Asunto
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '02. ASUNTO DEL EMAIL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _subjectController,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'NUEVO DROP DISPONIBLE 🏴',
              filled: true,
              fillColor: const Color(0xFFF4F4F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 03. Titulo Hero
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '03. TÍTULO HERO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'THE FUTURE OF UTILITY',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF18181B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: const BorderSide(
                  color: Color(0xFF27272A),
                  width: 4,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 24,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 04. Cuerpo
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '04. CUERPO DEL MENSAJE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _bodyController,
            maxLines: 6,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: 'Redacta el contenido de tu mensaje...',
              filled: true,
              fillColor: const Color(0xFFF4F4F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 32,
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _executeCampaign,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF09090B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                elevation: 10,
              ),
              child: const Text(
                'EJECUTAR LANZAMIENTO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateBtn extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _TemplateBtn({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF18181B) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF18181B) : Colors.grey[200]!,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.grey[400] : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
