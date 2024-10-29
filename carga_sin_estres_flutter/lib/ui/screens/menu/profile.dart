import 'package:carga_sin_estres_flutter/data/models/customer.dart';
import 'package:carga_sin_estres_flutter/data/models/customer_update.dart';
import 'package:carga_sin_estres_flutter/data/services/customer_service.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/message_dialog.dart';
import 'package:carga_sin_estres_flutter/utils/theme.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/custom_bottom_navigation_bar.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/date_of_birth_input.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/form_input.dart';
import 'package:carga_sin_estres_flutter/ui/widgets/password_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  int? userId;
  Customer? customer;
  bool _isEditButtonEnabled = false;
  bool _isLoading = true;

  String _initialFirstName = '';
  String _initialLastName = '';
  String _initialPhoneNumber = '';
  String _initialEmail = '';
  String _initialDateOfBirth = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _addListeners() {
    _firstNameController.addListener(_checkForChanges);
    _lastNameController.addListener(_checkForChanges);
    _phoneNumberController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _passwordController.addListener(_checkForChanges);
    _confirmPasswordController.addListener(_checkForChanges);
    _dateOfBirthController.addListener(_checkForChanges);
  }

  void _removeListeners() {
    _firstNameController.removeListener(_checkForChanges);
    _lastNameController.removeListener(_checkForChanges);
    _phoneNumberController.removeListener(_checkForChanges);
    _emailController.removeListener(_checkForChanges);
    _passwordController.removeListener(_checkForChanges);
    _confirmPasswordController.removeListener(_checkForChanges);
    _dateOfBirthController.removeListener(_checkForChanges);
  }

  void _checkForChanges() {
    if (_isLoading)
      return; // No habilitar el botón mientras los datos se están cargando

    setState(() {
      _isEditButtonEnabled = _firstNameController.text != _initialFirstName ||
          _lastNameController.text != _initialLastName ||
          _phoneNumberController.text != _initialPhoneNumber ||
          _emailController.text != _initialEmail ||
          _dateOfBirthController.text != _initialDateOfBirth ||
          _passwordController.text.isNotEmpty ||
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _removeListeners();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    if (userId != null) {
      try {
        CustomerService customerService = CustomerService();
        Customer fetchedCustomer =
            await customerService.getCustomerById(userId!);

        // Desactivar los listeners mientras se cargan los datos
        _removeListeners();

        setState(() {
          customer = fetchedCustomer;

          // Asignar los valores obtenidos del cliente a los controladores
          _firstNameController.text = fetchedCustomer.firstName;
          _lastNameController.text = fetchedCustomer.lastName;
          _phoneNumberController.text = fetchedCustomer.phoneNumber;
          _emailController.text = fetchedCustomer.email;
          _dateOfBirthController.text =
              DateFormat('dd/MM/yyyy').format(fetchedCustomer.dateOfBirth);

          // Guardar los valores iniciales para compararlos después
          _initialFirstName = fetchedCustomer.firstName;
          _initialLastName = fetchedCustomer.lastName;
          _initialPhoneNumber = fetchedCustomer.phoneNumber;
          _initialEmail = fetchedCustomer.email;
          _initialDateOfBirth =
              DateFormat('dd/MM/yyyy').format(fetchedCustomer.dateOfBirth);

          _isLoading = false; // Datos cargados completamente
        });

        // Agregar los listeners nuevamente después de cargar los datos
        _addListeners();
      } catch (e) {
        print('Error al obtener el cliente: $e');
      }
    }
  }

  Future<void> _updateCustomerData() async {
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    if (userId != null) {
      try {
        CustomerService customerService = CustomerService();
        CustomerUpdate updatedCustomer = CustomerUpdate(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phoneNumber: _phoneNumberController.text,
          email: _emailController.text,
          dateOfBirth:
              DateFormat('dd/MM/yyyy').parse(_dateOfBirthController.text),
          password: _passwordController.text.isNotEmpty
              ? _passwordController.text
              : null, // Solo enviar la contraseña si el usuario la ingresó
        );

        await customerService.updateCustomerById(userId!, updatedCustomer);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado con éxito')),
        );

        // Aquí puedes decidir si redirigir al usuario después de actualizar el perfil
        Navigator.pushNamed(context, '/home');
      } catch (e) {
        print('Error al actualizar el cliente: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el perfil: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double inputWidth = screenWidth * 0.90;

    return Scaffold(
      backgroundColor: AppTheme.primaryWhite,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Perfil',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.secondaryBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Center(
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Color(0xFFECECEC),
                          child: Icon(
                            Icons.person,
                            size: 70,
                            color: AppTheme.secondaryGray,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      FormInput(
                        inputWidth: inputWidth,
                        labelText: 'Nombres',
                        icon: Icons.person,
                        controller: _firstNameController,
                        hintText: '',
                      ),
                      const SizedBox(height: 20),
                      FormInput(
                        inputWidth: inputWidth,
                        labelText: 'Apellidos',
                        icon: Icons.person,
                        controller: _lastNameController,
                        hintText: '',
                      ),
                      const SizedBox(height: 20),
                      FormInput(
                        inputWidth: inputWidth,
                        labelText: 'Número de celular',
                        icon: Icons.phone,
                        controller: _phoneNumberController,
                        hintText: '',
                      ),
                      const SizedBox(height: 20),
                      DateOfBirthInput(
                        inputWidth: inputWidth,
                        labelText: 'Fecha de nacimiento',
                        controller: _dateOfBirthController,
                        hintText: '',
                      ),
                      const SizedBox(height: 20),
                      FormInput(
                        inputWidth: inputWidth,
                        labelText: 'Correo electrónico',
                        icon: Icons.email,
                        controller: _emailController,
                        hintText: '',
                      ),
                      const SizedBox(height: 20),
                      PasswordInput(
                        inputWidth: inputWidth,
                        labelText: 'Contraseña',
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 20),
                      PasswordInput(
                        inputWidth: inputWidth,
                        labelText: 'Confirmar contraseña',
                        controller: _confirmPasswordController,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: inputWidth,
              child: ElevatedButton(
                onPressed: _isEditButtonEnabled
                    ? () {
                        messageDialog(
                          context,
                          '¿Deseas editar tu perfil?',
                          'Editar Perfil',
                          () async {
                            // Llamar a la función para actualizar los datos del cliente
                            await _updateCustomerData();

                            // Luego de la actualización, desactiva el botón de edición
                            setState(() {
                              _isEditButtonEnabled = false;
                            });
                          },
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEditButtonEnabled
                      ? const Color(0xFFFF5757)
                      : Colors
                          .grey, // Cambia el color cuando el botón está deshabilitado
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Editar Perfil',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
