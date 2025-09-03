import Joi from 'joi';

/**
 * Base User Schema
 * ----------------
 * This schema defines all possible fields for a User document.
 * We will extend this base schema into specialized schemas
 * for different use cases (registration, update, login).
 */
const UserSchema = Joi.object({
  // User's full name (required)
  name: Joi.string().trim().required().messages({
    'string.empty': 'Name is required',
    'any.required': 'Name is required'
  }),

  // Email address (required, must be valid email format, lowercase, trimmed)
  email: Joi.string().email().lowercase().trim().required().messages({
    'string.email': 'Please provide a valid email address',
    'string.empty': 'Email is required',
    'any.required': 'Email is required'
  }),

  // Password hash stored in DB (required at schema level, 
  // but in login we will use raw "password" field instead)
  password: Joi.string().required().messages({
    'string.empty': 'Password is required',
    'any.required': 'Password is required'
  }),

  // Role: only "user" or "admin" allowed, defaults to "user"
  role: Joi.string().valid('user', 'admin').default('user'),

  // Whether account is active (defaults to true)
  active: Joi.boolean().default(true),

  // Email verification status
  verified: Joi.boolean().default(false),
  verificationToken: Joi.string().allow('', null),   // Token for email verification
  verificationExpires: Joi.date().allow(null),       // Expiry for verification token

  // Forgot password reset fields
  resetPasswordToken: Joi.string().allow('', null),  // Token for reset password
  resetPasswordExpires: Joi.date().allow(null)       // Expiry for reset password token
})
.options({ stripUnknown: true }); // Remove any unknown fields not defined in schema


/**
 * Registration Schema
 * -------------------
 * Used when a new user registers.
 * Requires: name, email, passwordHash
 */
const UserRegistrationSchema = UserSchema.keys({
  name: Joi.string().trim().required(),
  email: Joi.string().email().lowercase().trim().required(),
  password: Joi.string().required()
});


/**
 * Update Schema
 * -------------
 * Used when updating user details.
 * - All fields optional (name, email, passwordHash, role)
 * - Must provide at least one field (`.min(1)`)
 */
const UserUpdateSchema = UserSchema.keys({
  name: Joi.string().trim(),
  email: Joi.string().email().lowercase().trim(),
  password: Joi.string(),
  role: Joi.string().valid('user', 'admin')
}).min(1);


/**
 * Login Schema
 * ------------
 * Used when user tries to log in.
 * Requires: email + raw password (not passwordHash)
 */
const UserLoginSchema = Joi.object({
  email: Joi.string().email().lowercase().trim().required().messages({
    'string.email': 'Please provide a valid email address',
    'string.empty': 'Email is required',
    'any.required': 'Email is required'
  }),
  password: Joi.string().required().messages({
    'string.empty': 'Password is required',
    'any.required': 'Password is required'
  })
}).options({ stripUnknown: true }); // Strip out extra fields


export { UserSchema, UserRegistrationSchema, UserUpdateSchema, UserLoginSchema };
