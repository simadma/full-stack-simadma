<script lang="ts">
	import { onMount } from 'svelte';
	let inputRef: HTMLInputElement | null = null;

	const API_URL = import.meta.env.VITE_API_URL;

	let message = '';
	let input = '';
	let loading = false;
	let error = '';

	const fetchData = async (endpoint: string, options?: RequestInit) => {
		loading = true;
		error = '';
		try {
			const res = await fetch(`${API_URL}${endpoint}`, options);
			if (!res.ok) throw new Error();
			return await res.json();
		} catch {
			error = endpoint === '/' ? 'Could not reach the API.' : 'Failed to send message.';
			return null;
		} finally {
			loading = false;
		}
	};

	const fetchMessage = async () => {
		const data = await fetchData('/');
		if (data) message = data.message;
	};

	const sendMessage = async () => {
		if (!input) return;
		const data = await fetchData('/echo', {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({ text: input })
		});
		if (data) {
			message = data.text;
			input = '';
			inputRef?.focus(); // <-- Refocus input after sending
		}
	};

	const handleKey = (e: KeyboardEvent) => e.key === 'Enter' && sendMessage();

	onMount(fetchMessage);
</script>

<main
	class="flex min-h-screen flex-col items-center justify-center bg-gradient-to-b from-purple-50 via-purple-100 to-purple-200 p-8 text-center"
>
	<h1 class="mb-6 text-4xl font-extrabold text-purple-800 drop-shadow-md md:text-5xl">
		Welcome to My Website
	</h1>

	<div class="mb-6 w-full max-w-md rounded-xl bg-white p-6 shadow-md">
		<p class="mb-4 text-lg text-gray-700 md:text-xl">
			{#if loading}Loading...{:else if error}{error}{:else if message}{message}{/if}
		</p>
		<div class="flex gap-2">
			<input
				bind:this={inputRef}
				type="text"
				placeholder="Type something..."
				bind:value={input}
				on:keydown={handleKey}
				disabled={loading}
				class="flex-1 rounded-lg border border-gray-300 px-4 py-2 shadow-sm transition focus:border-purple-500 focus:outline-none focus:ring-2 focus:ring-purple-500"
			/>
			<button
				on:click={sendMessage}
				disabled={loading || !input}
				class="rounded-lg bg-purple-600 px-6 py-2 font-medium text-white shadow transition hover:bg-purple-700 active:bg-purple-800"
			>
				{loading ? 'Sending...' : 'Send'}
			</button>
		</div>
	</div>

	<footer class="mt-12 text-sm text-gray-500">Powered by FastAPI + SvelteKit + Tailwind</footer>
</main>
