<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('ruangan_booking', function (Blueprint $table) {
            $table->id();
            $table->enum('ruangan', ['GD511', 'GD513', 'GD515'])->nullable();
            $table->foreignId('user_id')->constrained('users','id');
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
            $table->dateTime('start_time');
            $table->dateTime('end_time');
            $table->timestamps();

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('booking_ruangan');
    }
};
