/**
 * Bun SSR Wrapper
 *
 * This wrapper script is used by LiveSvelte.SSR.Bun to execute server-side
 * rendering using Bun. It imports the server.js render function and calls it
 * with arguments passed from Elixir.
 *
 * Usage: bun bun_ssr_wrapper.js <server_path> <component_name> <props_json> <slots_json>
 */

// Get the server.js path from command line arguments
const serverPath = Bun.argv[2];
const componentName = Bun.argv[3];
const propsJson = Bun.argv[4];
const slotsJson = Bun.argv[5];

// Dynamically import the server module
const { render } = await import(serverPath);

// Parse the JSON arguments
const props = JSON.parse(propsJson);
const slots = JSON.parse(slotsJson);

// Call the render function
const result = render(componentName, props, slots);

// Access the getters to extract the actual values
const output = {
  html: result.html,
  head: result.head,
  body: result.body
};

// Output the result as JSON
console.log(JSON.stringify(output));
