const Joi = require('joi');

const UserSchema = Joi.object({
  name: Joi.string().trim().required().messages({
    'string.empty': 'Name is required',
    'any.required': 'Name is required'
  }),
  email: Joi.string().email().lowercase().trim().required().messages({
    'string.email': 'Please provide a valid email address',
    'string.empty': 'Email is required',
    'any.required': 'Email is required'
  }),
  passwordHash: Joi.string().required().messages({
    'string.empty': 'Password is required',
    'any.required': 'Password is required'
  }),
  role: Joi.string().valid('user', 'admin').default('user'),
  active: Joi.boolean().default(true),
  verified: Joi.boolean().default(false),
  verificationToken: Joi.string().allow('', null),
  verificationExpires: Joi.date().allow(null),
  resetPasswordToken: Joi.string().allow('', null),
  resetPasswordExpires: Joi.date().allow(null)
}).options({ stripUnknown: true });

// For user registration (typically requires name, email, password)
const UserRegistrationSchema = UserSchema.keys({
  name: Joi.string().trim().required(),
  email: Joi.string().email().lowercase().trim().required(),
  passwordHash: Joi.string().required()
});

// For user updates (all fields optional except restrictions on some)
const UserUpdateSchema = UserSchema.keys({
  name: Joi.string().trim(),
  email: Joi.string().email().lowercase().trim(),
  passwordHash: Joi.string(),
  role: Joi.string().valid('user', 'admin')
}).min(1); // At least one field must be provided

// For the safe JSON output (what to return to client)
const UserSafeSchema = Joi.object({
  _id: Joi.any(),
  name: Joi.string().required(),
  email: Joi.string().email().required(),
  role: Joi.string().valid('user', 'admin').required(),
  active: Joi.boolean().required(),
  verified: Joi.boolean().required()
});

module.exports = {
  UserSchema,
  UserRegistrationSchema,
  UserUpdateSchema,
  UserSafeSchema
};