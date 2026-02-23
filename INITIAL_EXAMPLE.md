> **Note:** This is a sample INITIAL.md for a real project. The `examples/` paths below are project-specific — you would populate `examples/` with your own code before writing an INITIAL.md like this. See `examples/README.md` for guidance.

## FEATURE:

- Pydantic AI agent that has another Pydantic AI agent as a tool.
- Research Agent for the primary agent and then an email draft Agent for the subagent.
- CLI to interact with the agent.
- Gmail for the email draft agent, Brave API for the research agent.

## EXAMPLES:

In the `examples/` folder, I have included examples of other implementations in our codebase that you should mimic. Please review `examples/README.md` to see what is included.

- `examples/cli_template/` — use this as a pattern to create the CLI
- `examples/agent_pattern/` — read through to understand best practices for creating Pydantic AI agents that support different providers and LLMs

Don't copy any of these examples directly, use them as inspiration and for patterns.

## DOCUMENTATION:

- Pydantic AI documentation: https://ai.pydantic.dev/
- Pydantic AI multi-agent patterns: https://ai.pydantic.dev/multi-agent-applications/

## OTHER CONSIDERATIONS:

- Include a `.env.example` and README with instructions for setup, including how to configure Gmail and Brave.
- Include the project structure in the README.
- Virtual environment has already been set up with the necessary dependencies.
- Use `python-dotenv` and `load_dotenv()` for environment variables.
- Pydantic AI requires async throughout — no sync functions in async agent context.
