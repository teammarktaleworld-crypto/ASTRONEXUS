import fs from 'fs-extra';
import path from 'path';
import { fileURLToPath } from 'url';
import { callModel, extractResponseText } from '../lib/openaiClient.js';
import { buildSystemPrompt } from '../lib/retrieval.js';
// import { retrieveContextForQuery } from '../lib/retrieval.js'; // Temporarily disabled

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const HISTORY_FILE = path.join(__dirname, '../store/history.json');

/**
 * Load session history from file
 * @returns {Promise<Object>} Session history object
 */
async function loadHistory() {
  try {
    await fs.ensureFile(HISTORY_FILE);
    const content = await fs.readFile(HISTORY_FILE, 'utf-8');
    return content ? JSON.parse(content) : {};
  } catch (error) {
    return {};
  }
}

/**
 * Save session history to file
 * @param {Object} history - Session history object
 */
async function saveHistory(history) {
  const tempFile = `${HISTORY_FILE}.tmp`;
  await fs.writeJson(tempFile, history, { spaces: 2 });
  await fs.move(tempFile, HISTORY_FILE, { overwrite: true });
}

// extractResponseText is now imported from openaiClient.js

/**
 * Handle chat request
 * @param {Object} req - Express request
 * @param {Object} res - Express response
 */
export async function handleChat(req, res) {
  try {
    const { userId, sessionId, message, max_context_docs } = req.body;

    // Validate input
    if (!message || typeof message !== 'string') {
      return res.status(400).json({
        ok: false,
        error: 'Message is required and must be a string',
      });
    }

    if (!sessionId) {
      return res.status(400).json({
        ok: false,
        error: 'sessionId is required',
      });
    }

    // const topK = max_context_docs || 5; // Temporarily disabled
    const model = process.env.OPENAI_MODEL || 'gpt-4o-mini';

    if (!model) {
      return res.status(500).json({
        ok: false,
        error: 'OPENAI_MODEL not configured',
      });
    }

    // Retrieve relevant context - TEMPORARILY DISABLED
    // const { docs, retrievedContext } = await retrieveContextForQuery(message, topK);
    const docs = []; // Empty for now

    // Build messages array for OpenAI
    const systemPrompt = buildSystemPrompt();
    
    const messages = [
      {
        role: 'system',
        content: systemPrompt
      },
      {
        role: 'user',
        content: message
      }
    ];

    // Call OpenAI model
    const modelResponse = await callModel({
      model,
      messages,
      temperature: 0.3,
      max_tokens: 512,
    });

    // Extract response text
    const responseText = extractResponseText(modelResponse);

    // Parse JSON response from model
    let parsedResponse;
    try {
      // Try to extract JSON from response
      const jsonMatch = responseText.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        parsedResponse = JSON.parse(jsonMatch[0]);
      } else {
        parsedResponse = JSON.parse(responseText);
      }
    } catch (error) {
      // Fallback if JSON parsing fails
      parsedResponse = {
        answer: responseText,
        citations: [],
        raw: 'Response was not in expected JSON format',
      };
    }

    // Load and update session history
    const history = await loadHistory();
    if (!history[sessionId]) {
      history[sessionId] = [];
    }

    history[sessionId].push(
      {
        role: 'user',
        content: message,
        timestamp: new Date().toISOString(),
      },
      {
        role: 'assistant',
        content: parsedResponse.answer,
        timestamp: new Date().toISOString(),
      }
    );

    await saveHistory(history);

    // Prepare response (sources empty for now since embeddings are disabled)
    const sources = [];

    // Minimize raw model response (remove sensitive data)
    const rawModelResponse = {
      model: modelResponse.model || model,
      usage: modelResponse.usage,
    };

    res.json({
      ok: true,
      answer: parsedResponse.answer,
      citations: parsedResponse.citations || [],
      sources,
      rawModelResponse,
    });

  } catch (error) {
    console.error('[chatController] Error:', error);
    res.status(500).json({
      ok: false,
      error: error.message || 'Internal server error',
    });
  }
}
