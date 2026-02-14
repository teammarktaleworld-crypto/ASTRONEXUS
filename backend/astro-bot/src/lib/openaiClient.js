import fetch from 'node-fetch';

const BASE_URL = 'https://api.openai.com/v1';

/**
 * Call OpenAI model for chat completions
 * @param {Object} options
 * @param {string} options.model - Model identifier (e.g., gpt-4o-mini)
 * @param {Array} options.messages - Array of message objects with role and content
 * @param {number} [options.temperature=0.3] - Temperature for sampling
 * @param {number} [options.max_tokens=512] - Maximum tokens to generate
 * @returns {Promise<Object>} Parsed response from OpenAI API
 */
export async function callModel({ model, messages, temperature = 0.3, max_tokens = 512 }) {
  const API_KEY = process.env.OPENAI_API_KEY;
  const isDev = process.env.NODE_ENV !== 'production';
  
  if (!API_KEY) {
    throw new Error('OPENAI_API_KEY is not set in environment variables');
  }

  const url = `${BASE_URL}/chat/completions`;
  
  const body = {
    model,
    messages,
    temperature,
    max_tokens,
  };

  if (isDev) {
    console.debug('[openaiClient] Calling model:', model);
    console.debug('[openaiClient] Messages:', JSON.stringify(messages, null, 2));
  }

  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${API_KEY}`,
      },
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      const errorText = await response.text();
      if (isDev) {
        console.debug('[openaiClient] Error response:', errorText);
      }
      throw new Error(`OpenAI API error (${response.status}): ${errorText}`);
    }

    const data = await response.json();
    
    if (isDev) {
      console.debug('[openaiClient] Response received:', JSON.stringify(data, null, 2));
    }

    return data;
  } catch (error) {
    console.error('[openaiClient] Request failed:', error.message);
    throw error;
  }
}

/**
 * Extract text from OpenAI API response
 * @param {Object} response - API response
 * @returns {string} Extracted text
 */
export function extractResponseText(response) {
  if (response.choices?.[0]?.message?.content) {
    return response.choices[0].message.content;
  }
  
  throw new Error('Unable to extract text from OpenAI response');
}

// Note: Embeddings functionality temporarily disabled
// Will be re-enabled when switching back to Together AI or using OpenAI embeddings
/**
 * Generate embeddings for text (TEMPORARILY DISABLED)
 * @param {string} text - Text to embed
 * @param {Object} options
 * @returns {Promise<Object>} Placeholder response
 */
export async function embedText(text, options = {}) {
  console.warn('[openaiClient] Embeddings are temporarily disabled');
  // Return a placeholder to prevent errors
  return {
    data: [{
      embedding: null
    }]
  };
}
