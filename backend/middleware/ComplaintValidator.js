import Joi from 'joi';

// ---------------- Create Complaint Validator ----------------
export const createComplaintValidator = Joi.object({
  title: Joi.string().trim().required().messages({
    'string.empty': 'Title is required',
    'any.required': 'Title is required',
  }),

  description: Joi.string().trim().required().messages({
    'string.empty': 'Description is required',
    'any.required': 'Description is required',
  }),

  category: Joi.string()
    .valid('IT Department', 'HR Department', 'Finance', 'Facilities', 'Security', 'Other')
    .default('Other')
    .messages({
      'any.only': 'Invalid category selected',
    }),

  priority: Joi.string()
    .valid('Low', 'Medium', 'High')
    .default('Medium')
    .messages({
      'any.only': 'Invalid priority selected',
    }),

  phone: Joi.string()
    .pattern(/^[0-9]{10,15}$/)
    .required()
    .messages({
      'string.pattern.base': 'Enter a valid phone number',
      'string.empty': 'Phone number is required',
      'any.required': 'Phone number is required',
    }),

  email: Joi.string()
    .email({ tlds: { allow: false } })
    .required()
    .messages({
      'string.email': 'Enter a valid email address',
      'string.empty': 'Email is required',
      'any.required': 'Email is required',
    }),

    attachments: Joi.array()
    .items(Joi.string().uri().messages({
      'string.uri': 'Each attachment must be a valid file URL',
    }))
    .optional()
    .messages({
      'array.base': 'Attachments must be an array of file URLs',
    }),
});

// Add a default export as well for compatibility
export default { createComplaintValidator };