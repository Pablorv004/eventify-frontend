import 'package:eventify/domain/models/event.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizerEventForm extends StatefulWidget {
  const OrganizerEventForm({super.key, this.event});
  final Event? event;

  @override
  _OrganizerEventFormState createState() => _OrganizerEventFormState();
}

class _OrganizerEventFormState extends State<OrganizerEventForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _maxAttendeesController;
  late DateTime _startTime;
  late DateTime _endTime;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<EventProvider>().fetchCategories();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController = TextEditingController(text: widget.event?.description ?? '');
    _locationController = TextEditingController(text: widget.event?.location ?? '');
    _priceController = TextEditingController(text: widget.event?.price?.toString() ?? '');
    _imageUrlController = TextEditingController(text: widget.event?.imageUrl ?? '');
    _latitudeController = TextEditingController(text: widget.event?.latitude?.toString() ?? '');
    _longitudeController = TextEditingController(text: widget.event?.longitude?.toString() ?? '');
    _maxAttendeesController = TextEditingController(text: widget.event?.maxAttendees?.toString() ?? '');
    _startTime = widget.event?.startTime ?? DateTime.now();
    _endTime = widget.event?.endTime ?? DateTime.now().add(const Duration(hours: 1));
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartTime) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartTime ? _startTime : _endTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStartTime ? _startTime : _endTime),
      );
      if (pickedTime != null) {
        setState(() {
          final DateTime selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStartTime) {
            _startTime = selectedDateTime;
          } else {
            _endTime = selectedDateTime;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.read<EventProvider>();
    final userProvider = context.read<UserProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'Add Event' : 'Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: eventProvider.categoryList.toSet().map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id.toString(),
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              if (widget.event != null) ...[
                TextFormField(
                  controller: _latitudeController,
                  decoration: const InputDecoration(labelText: 'Latitude'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a latitude';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _longitudeController,
                  decoration: const InputDecoration(labelText: 'Longitude'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a longitude';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _maxAttendeesController,
                  decoration: const InputDecoration(labelText: 'Max Attendees'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the maximum number of attendees';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ],
              ListTile(
                title: Text('Start Time: ${_startTime.toLocal().toString().split(' ')[0]} ${_startTime.toLocal().toString().split(' ')[1].substring(0, 5)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context, true),
              ),
              ListTile(
                title: Text('End Time: ${_endTime.toLocal().toString().split(' ')[0]} ${_endTime.toLocal().toString().split(' ')[1].substring(0, 5)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context, false),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_startTime.isBefore(DateTime.now())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Start time must be after today')),
                      );
                      return;
                    }
                    if (_startTime.isAfter(_endTime)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Start time must be before end time')),
                      );
                      return;
                    }
                    final event = Event(
                      id: widget.event?.id ?? 0,
                      organizerId: userProvider.currentUser?.id,
                      title: _titleController.text,
                      description: _descriptionController.text.isEmpty ? 'No Description Provided.' : _descriptionController.text,
                      category: _selectedCategory,
                      startTime: _startTime,
                      endTime: _endTime,
                      location: _locationController.text,
                      price: double.tryParse(_priceController.text),
                      imageUrl: _imageUrlController.text,
                      latitude: widget.event != null ? double.tryParse(_latitudeController.text) : null,
                      longitude: widget.event != null ? double.tryParse(_longitudeController.text) : null,
                      maxAttendees: widget.event != null ? int.tryParse(_maxAttendeesController.text) : null,
                    );
                    if (widget.event == null) {
                      await eventProvider.createEvent(event);
                    } else {
                      await eventProvider.updateEvent(event);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event saved successfully')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.event == null ? 'Add Event' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}